import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/model/transaction_info.dart';
import 'package:web3dart/web3dart.dart';

class ParamsProvider extends ChangeNotifier {
  int _selTokenId = 0;
  String _pinCode = '';
  bool _askTransaction = false;
  Widget? _nextPage;
  Transaction? _signedTx;
  String _amount = '0';
  String _receiver = '';
  String? _walletconnectUrl = '';
  bool _connected = false;
  TransactionInfo _transaction = new TransactionInfo();
  bool _isActive = false;

  int get selTokenId => _selTokenId;
  String get pinCode => _pinCode;
  Widget? get nextPage => _nextPage;
  bool get askTransaction => _askTransaction;
  Transaction? get signedTx => _signedTx;
  String get amount => _amount;
  String get receiver => _receiver;
  String? get walletconnectUrl => _walletconnectUrl;
  bool get connected => _connected;
  TransactionInfo get transaction => _transaction;
  bool get isActive => _isActive;

  void setWalletConnectUrl(String uri){
    this._walletconnectUrl = uri;
    notifyListeners();
  }

  void setWalletConnect(bool f){
    _connected = f;
    notifyListeners();
  }

  void setTokenId(id){
    _selTokenId = id;
    notifyListeners();
  }

  void setPinCode(String code){
    _pinCode = code;
    notifyListeners();
  }

  void setNextPage(Widget w){
    _nextPage = w;
    notifyListeners();
  }

  void setAskTransaction(bool f){
    _askTransaction = f;
    notifyListeners();
  }

  void setSignedTransaction(Transaction tx){
    _signedTx = tx;
    notifyListeners();
  }

  void setAmount(String val){
    _amount = val;
    notifyListeners();
  }

  void setReceiver(String address){
    _receiver = address;
    notifyListeners();
  }

  void setTransaction(TransactionInfo tx){
    _transaction = tx;
    notifyListeners();
  }

  void setIsActive(bool f){
    _isActive = f;
    notifyListeners();
  }
}