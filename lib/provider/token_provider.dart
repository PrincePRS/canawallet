import 'dart:async';
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/coins/PricedCoin.dart';
import 'package:coingecko_dart/dataClasses/coins/SimpleToken.dart';
import 'package:flutter/cupertino.dart';
import 'package:cancoin_wallet/constants/chains.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/language/cn_ch.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:web3dart/web3dart.dart';

class TokenProvider extends ChangeNotifier{
  List<TokenInfo> _allTokens = [];
  List<TokenInfo> _tokens = [];
  int _curNetwork = 0;
  double _totalBalance = 0;
  int _setId = 0;
  int _network = 0; // used in add custom tokens
  Timer? _timer;
  int _counter = 0;
  List<String> _log = [];

  int get setId => _setId;
  double get totalBalance => _totalBalance;
  List<TokenInfo> get tokens => _tokens;
  List<TokenInfo> get allTokens => _allTokens;
  int get network => _network;
  int get curNetwork => _curNetwork;
  int get counter => _counter;
  List<String> get log => _log;

  TokenProvider(){
    // initValues();
  }

  initValues() async{
    await sqliteController.open();
    List<TokenInfo> tokens = await sqliteController.getTokenList();
    this.setAllTokens(tokens);
    storageController.instance!.setInt('network', 0);
    web3Controller.changeNetwork(0);
    notifyListeners();

    int? chain = storageController.instance!.getInt('network');
    if(chain == null){
      storageController.instance!.setInt('network', 0);
    }else{
      this.changeNetwork(chain);
    }
  }

  startTimer(){
    _timer = Timer.periodic(new Duration(seconds: 30), (timer){
      this.getBalance();
      _counter ++;
      notifyListeners();
    });
  }

  stopTimer(){
    _timer!.cancel();
  }

  void calcTotalbalance(){
    double value = 0;
    for(var i = 0; i < this._tokens.length; i ++){
      value += storageController.instance!.getDouble(Strings.suffixAmount + this._tokens[i].name)! * storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;
    }
    this.setTotalBalance(double.parse(value.toStringAsFixed(2)));
  }

  void setTotalBalance(double val){
    _totalBalance = val;
  }

  void getPriceInfo() async{
    double price = 0;
    double change = 0;
    List<String> contracts = [];
    for(var i = 0; i < this._tokens.length; i ++) {
      if(this._tokens[i].address != '') contracts.add(this._tokens[i].address);
    }

    for(var i = 0; i < this._tokens.length; i ++) {
      if(storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name) == null){
        storageController.instance!.setDouble(Strings.suffixPrice + this._tokens[i].name, 0.0);
      }
      this._tokens[i].price = storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;

      if(storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name) == null){
        storageController.instance!.setDouble(Strings.suffixChange + this._tokens[i].name, 0.0);
      }
      this._tokens[i].change = storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name)!;
    }

    if(_curNetwork == 2) return;
    CoinGeckoResult<List<SimpleToken>> result = await coinGeckoApi.simpleTokenPrice(id: Chains.chains[_curNetwork].name, contractAddresses: contracts, vs_currencies: ['usd'], include24hChange: true);
    result.data.forEach((element) {
      for(var i = 0; i < this._tokens.length; i ++){
        if(this._tokens[i].address.toUpperCase() == element.contractAddress.toUpperCase()) {
          price = double.parse(element.data['usd']!.toStringAsFixed(2));
          change = double.parse(element.data['usd_24h_change']!.toStringAsFixed(2));
          storageController.instance!.setDouble(Strings.suffixPrice + this._tokens[i].name, price);
          storageController.instance!.setDouble(Strings.suffixChange + this._tokens[i].name, change);
          this._tokens[i].price = storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;
          this._tokens[i].change = storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name)!;
        }
      }
    });

    List<String> ids = [];
    for(var i = 0; i < this._tokens.length; i ++){
      ids.add(this._tokens[i].tokenId);
    }

    CoinGeckoResult<List<PricedCoin>> res = await coinGeckoApi.simplePrice(ids: ids, vs_currencies: ['usd'], include24hChange: true);
    res.data.forEach((element) {
      for(var i = 0; i < this._tokens.length; i ++) {
        if(this._tokens[i].address == '' && this._tokens[i].tokenId.toUpperCase() == element.coinData!.id.toUpperCase()) {
          price  = double.parse(element.data['usd']!.toStringAsFixed(2));
          change = double.parse(element.data['usd_24h_change']!.toStringAsFixed(2));
          storageController.instance!.setDouble(Strings.suffixPrice + this._tokens[i].name, price);
          storageController.instance!.setDouble(Strings.suffixChange + this._tokens[i].name, change);
          this._tokens[i].price = storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;
          this._tokens[i].change = storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name)!;

        }
      }
    });
  }

  void getBalance() async{
    for(var i = 0; i < this._tokens.length; i ++) {
      if(storageController.instance!.getDouble(Strings.suffixAmount + this._tokens[i].name) == null){
        storageController.instance!.setDouble(Strings.suffixAmount + this._tokens[i].name, 0.0);
      }
      this._tokens[i].balance = storageController.instance!.getDouble(Strings.suffixAmount + this._tokens[i].name)!;
    }
    double tp = 0;
    log.add('-----------------------1');
    try{
      for(var i = 0; i < this._tokens.length; i ++) {
        if(this._tokens[i].address == ''){
          log.add('=====   1');
          EtherAmount am = await web3Controller.getBalance();
          log.add('=====   11');
          tp = BigInt.from(am.getInWei / BigInt.from(10).pow(14)).toDouble();
          tp = tp / 10000.0;
          storageController.instance!.setDouble(Strings.suffixAmount + this._tokens[i].name, tp);
          this._tokens[i].balance = storageController.instance!.getDouble(Strings.suffixAmount + this._tokens[i].name)!;
          continue;
        }
        log.add('=====   2');
        BigInt b = await web3Controller.getTokenBalance(this._tokens[i].address);
        log.add('=====   22');
        tp = BigInt.from(b / BigInt.from(10).pow(14)).toDouble();
        tp = tp / 10000.0;
        storageController.instance!.setDouble(Strings.suffixAmount + this._tokens[i].name, tp);
        this._tokens[i].balance = storageController.instance!.getDouble(Strings.suffixAmount + this._tokens[i].name)!;
      }
    }catch(e){
      log.add('exception :  ' + e.toString());
    }

    // notifyListeners();

    double price = 0;
    double change = 0;
    List<String> contracts = [];
    for(var i = 0; i < this._tokens.length; i ++) {
      if(this._tokens[i].address != '') contracts.add(this._tokens[i].address);
    }
    log.add('----------------------------2');
    for(var i = 0; i < this._tokens.length; i ++) {
      if(storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name) == null){
        storageController.instance!.setDouble(Strings.suffixPrice + this._tokens[i].name, 0.0);
      }
      this._tokens[i].price = storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;

      if(storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name) == null){
        storageController.instance!.setDouble(Strings.suffixChange + this._tokens[i].name, 0.0);
      }
      this._tokens[i].change = storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name)!;
    }

    if(_curNetwork == 2) return;
    log.add('----------------------------3');
    CoinGeckoResult<List<SimpleToken>> result = await coinGeckoApi.simpleTokenPrice(id: Chains.chains[_curNetwork].name, contractAddresses: contracts, vs_currencies: ['usd'], include24hChange: true);
    result.data.forEach((element) {
      for(var i = 0; i < this._tokens.length; i ++){
        if(this._tokens[i].address.toUpperCase() == element.contractAddress.toUpperCase()) {
          price  = double.parse(element.data['usd']!.toStringAsFixed(2));
          change = double.parse(element.data['usd_24h_change']!.toStringAsFixed(2));
          storageController.instance!.setDouble(Strings.suffixPrice + this._tokens[i].name, price);
          storageController.instance!.setDouble(Strings.suffixChange + this._tokens[i].name, change);
          this._tokens[i].price = storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;
          this._tokens[i].change = storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name)!;
        }
      }
    });

    List<String> ids = [];
    for(var i = 0; i < this._tokens.length; i ++){
      ids.add(this._tokens[i].tokenId);
    }

    CoinGeckoResult<List<PricedCoin>> res = await coinGeckoApi.simplePrice(ids: ids, vs_currencies: ['usd'], include24hChange: true);
    log.add('coingecko-----  ' + res.data.length.toString());

    res.data.forEach((element) {
      log.add('token-----  ' + element.coinData!.id);
      for(var i = 0; i < this._tokens.length; i ++) {
        if(this._tokens[i].address == '' && this._tokens[i].tokenId.toUpperCase() == element.coinData!.id.toUpperCase()) {
          price  = double.parse(element.data['usd']!.toStringAsFixed(2));
          change = double.parse(element.data['usd_24h_change']!.toStringAsFixed(2));
          storageController.instance!.setDouble(Strings.suffixPrice + this._tokens[i].name, price);
          storageController.instance!.setDouble(Strings.suffixChange + this._tokens[i].name, change);
          this._tokens[i].price = storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;
          this._tokens[i].change = storageController.instance!.getDouble(Strings.suffixChange + this._tokens[i].name)!;
        }
      }
    });

    double value = 0;

    for(var i = 0; i < this._tokens.length; i ++){
      value += storageController.instance!.getDouble(Strings.suffixAmount + this._tokens[i].name)! * storageController.instance!.getDouble(Strings.suffixPrice + this._tokens[i].name)!;
    }

    this.setTotalBalance(double.parse(value.toStringAsFixed(2)));
    notifyListeners();
  }
  
  void setAllTokens(List<TokenInfo> t) {
    _allTokens = t;
    notifyListeners();
  }

  void setTokens(List<TokenInfo> t) {
    _tokens = t;
    notifyListeners();
  }

  void addToken(TokenInfo t){
    _allTokens.add(t);
    List<TokenInfo> tp = [];
    _allTokens.forEach((element) {
      if(element.chainId == _curNetwork) tp.add(element);
    });
    _tokens = tp;
    this.getBalance();
    notifyListeners();
  }

  void toggleActive(int id){
    _allTokens[id].isActive = !_allTokens[id].isActive;

    notifyListeners();
  }

  toggleCurrentTokenActive(int id){
    _tokens[id].isActive = !_tokens[id].isActive;
    notifyListeners();
  }

  void setNetwork(id){
    _network = id;
    notifyListeners();
  }

  void changeNetwork(id){
    _curNetwork = id;
    web3Controller.changeNetwork(id);
    List<TokenInfo> tp = [];
    _allTokens.forEach((element) {
      if(element.chainId == id) tp.add(element);
    });
    this.setTokens(tp);
    this.getBalance();
    notifyListeners();
  }

  void changeSetId(id){
    this._setId = id;
    notifyListeners();
  }
}