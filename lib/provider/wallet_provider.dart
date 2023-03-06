import 'package:cancoin_wallet/model/wallet_info.dart';
import 'package:flutter/cupertino.dart';

class WalletProvider extends ChangeNotifier{
  List<WalletInfo> _wallets = [];
  int _curWallet = 0;

  List<WalletInfo> get wallets => _wallets;
  int get curWallet => _curWallet;

  void setWalletList(List<WalletInfo> w){
    _wallets = w;
    notifyListeners();
  }

  void addWallet(WalletInfo w){
    _wallets.add(w);
    notifyListeners();
  }

  void setWallet(int w){
    _curWallet = w;
    notifyListeners();
  }

  void updateWalletName(String address, String name){
    for(int i = 0; i < _wallets.length; i ++) if(_wallets[i].address == address) {
      _wallets[i].name = name;
    }
    notifyListeners();
  }

  void deleteWallet(String address){
    for(int i = 0; i < _wallets.length; i ++) if(_wallets[i].address == address) {
      _wallets.removeAt(i);
      break;
    }
    notifyListeners();
  }
}