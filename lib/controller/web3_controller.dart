import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/mnemonics.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/credentials.dart';
import 'package:http/http.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:hex/hex.dart';
import 'dart:math';
import 'package:decimal/decimal.dart';

class Web3Controller extends GetxController{
  Web3Client _client = new Web3Client(Strings.RPC_URL[0], new Client());
  Credentials? _credentials;
  int _networkId = 100;
  int _defaultGasLimit = 7000000;
  String _mnemonic = '';

  Web3Client get client => _client;
  Credentials? get credentials => _credentials;
  int get networkId => _networkId;
  int get defaultGasLimit => _defaultGasLimit;
  String get mnemonic => _mnemonic;

  Web3Controller(){
    _client = new Web3Client( Strings.RPC_URL[0], new Client());
    _networkId = Strings.chainIds[0];
    _defaultGasLimit = 7000000;
  }

  //  Recover wallet address

  void generateMnemonic() {
    this._mnemonic = bip39.generateMnemonic();
  }

  void setMnemonics(String mnemonics){
    this._mnemonic = mnemonics;
  }

  void changeNetwork(int id){
    _client = new Web3Client( Strings.RPC_URL[id], new Client());
    _networkId = Strings.chainIds[id];
  }

  List<String> getHintMnemonics(String hint, List<String> existingWords){
    hint = hint.trim();
    List<String> result = [];
    for(var i = 0; i < Mnemonics.count; i ++){
      if(hint.length > Mnemonics.lists[i].length) continue;
      if(existingWords.indexOf(Mnemonics.lists[i]) < 0 && hint == Mnemonics.lists[i].substring(0, hint.length)){
        result.add(Mnemonics.lists[i]);
        if(result.length >= 5) break;
      }
    }
    return result;
  }

  Future<bool> checkValidateMnemonics(String mnemnic) async{
    return bip39.validateMnemonic(mnemnic);
  }

  String privateKeyFromMnemonic(String mnemonic, {int childIndex = 0}) {
    String seed = bip39.mnemonicToSeedHex(mnemonic);
    bip32.BIP32 root = bip32.BIP32.fromSeed(HEX.decode(seed) as Uint8List);
    bip32.BIP32 child = root.derivePath("m/44'/60'/0'/0/$childIndex");
    String privateKey = HEX.encode(child.privateKey as List<int>);
    return privateKey;
  }

  Future<void> setCredentials(String privateKey) async {
    _credentials = await _client.credentialsFromPrivateKey(privateKey);
  }

  Future<String> getAddress() async {
    return (await _credentials!.extractAddress()).toString();
  }

  // Transaction

  Future<Transaction> _sendTransactionAndWaitForReceipt(
      Transaction transaction) async {

    try{
      var gas = await _client.getGasPrice();
      var maxgas = await _client.estimateGas(
        sender: EthereumAddress.fromHex(storageController.instance!.getString('accountAddress')!),
        to: transaction.to,
        data: transaction.data,
        value: transaction.value,
        gasPrice: gas,
      ).then((bigInt) => bigInt.toInt());
      transaction = Transaction(
        from: EthereumAddress.fromHex(storageController.instance!.getString('accountAddress')!),
        to: transaction.to,
        data: transaction.data,
        value: transaction.value,
        gasPrice: gas,
        maxGas: maxgas
      );

      print('sendTransactionAndWaitForReceipt');
      print('network id  -> ' + _networkId.toString());
      print('from  -> ' + transaction.from.toString());
      print('to  -> ' + transaction.to.toString());
      print('gasprice  -> ' + transaction.gasPrice.toString());
      print('value  -> ' + transaction.value.toString());
      print('data  -> ' + transaction.data.toString());
    }catch(ex){
      print(ex);
    }
    return transaction;
  }

  Future<String> confirmTransaction(Transaction transaction) async{
    String txHash = '';
    try{
      txHash = await _client.sendTransaction(_credentials!, transaction, chainId: _networkId);
    }catch(e){
      print('Transaction Failed');
    }

    print(txHash);

    TransactionReceipt? receipt;
    try {
      receipt = await _client.getTransactionReceipt(txHash);
    } catch (err) {
      print('could not get $txHash receipt, try again');
    }
    int delay = 1;
    int retries = 10;
    while (receipt == null) {
      print('waiting for receipt');
      await Future.delayed(new Duration(seconds: delay));
      delay *= 2;
      retries--;
      if (retries == 0) {
        throw 'transaction $txHash not mined yet...';
      }
      try {
        receipt = await _client.getTransactionReceipt(txHash);
        print(receipt);
      } catch (err) {
        print('could not get $txHash receipt, try again');
      }
    }
    return txHash;
  }

  Future<EtherAmount> getBalance({String? address}) async {
    EthereumAddress a;
    if (address != null && address != "") {
      a = EthereumAddress.fromHex(address);
    } else {
      a = EthereumAddress.fromHex(await getAddress());
    }
    return await _client.getBalance(a);
  }

  Future<Transaction> transfer(String receiverAddress, int amountInWei) async {
    print('transfer --> receiver: $receiverAddress, amountInWei: $amountInWei');

    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    EtherAmount amount = EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(amountInWei));

    return await _sendTransactionAndWaitForReceipt(Transaction(to: receiver, value: amount));
  }

  Future<DeployedContract> _contract(String contractName, String contractAddress) async {
    // String abi = ABI.get(contractName);
    // DeployedContract contract = DeployedContract(
    //     ContractAbi.fromJson(abi, contractName),
    //     EthereumAddress.fromHex(contractAddress));
    // return contract;

    final contractJson = jsonDecode(await rootBundle.loadString('assets/abi.json'));
    return DeployedContract(
        ContractAbi.fromJson(jsonEncode(contractJson['abi']), 'TargaryenCoin'),
        EthereumAddress.fromHex(contractAddress));
  }

  Future<List<dynamic>> _readFromContract(String contractName, String contractAddress, String functionName, List<dynamic> params) async {
    DeployedContract contract = await _contract(contractName, contractAddress);
    return await _client.call(
      contract: contract,
      function: contract.function(functionName),
      params: params
    );
  }

  Future<Transaction> _callContract(String contractName, String contractAddress, String functionName, List<dynamic> params) async {
    DeployedContract contract = await _contract(contractName, contractAddress);
    Transaction tx = Transaction.callContract(
        contract: contract,
        function: contract.function(functionName),
        parameters: params,
        from: EthereumAddress.fromHex(storageController.instance!.getString('accountAddress')!)
    );
    return await _sendTransactionAndWaitForReceipt(tx);
  }

  Future<dynamic> getTokenDetails(String tokenAddress) async {
    return {
      "name": (await _readFromContract('TargaryenCoin', tokenAddress, 'name', [])).first,
      "symbol":
      (await _readFromContract('TargaryenCoin', tokenAddress, 'symbol', [])).first,
      "decimals":
      (await _readFromContract('TargaryenCoin', tokenAddress, 'decimals', [])).first
    };
  }

  Future<dynamic> getTokenBalance(String tokenAddress, {String? address}) async {
    List<dynamic> params = [];
    if (address != null && address != "") {
      params = [EthereumAddress.fromHex(address)];
    } else {
      params = [EthereumAddress.fromHex(await getAddress())];
    }
    return (await _readFromContract('TargaryenCoin', tokenAddress, 'balanceOf', params)).first;
  }

  Future<Transaction> tokenTransfer(String tokenAddress, String receiverAddress, num tokensAmount) async {
    EthereumAddress receiver = EthereumAddress.fromHex(receiverAddress);
    dynamic tokenDetails = await getTokenDetails(tokenAddress);
    int tokenDecimals = int.parse(tokenDetails["decimals"].toString());
    Decimal tokensAmountDecimal = Decimal.parse(tokensAmount.toString());
    Decimal decimals = Decimal.parse(pow(10, tokenDecimals).toString());
    BigInt amount = BigInt.parse((tokensAmountDecimal * decimals).toString());
    return await _callContract('TargaryenCoin', tokenAddress, 'transfer', [receiver, amount]);
  }
}