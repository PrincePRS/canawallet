import 'package:cancoin_wallet/model/notification_info.dart';
import 'package:flutter/cupertino.dart';

class NotificationProvider extends ChangeNotifier{
  bool _tAlert = false;
  bool _pAlert = false;
  double _limitValue = 0;

  bool get tAlert => _tAlert;
  bool get pAlert => _pAlert;
  double get limitValue => _limitValue;

  void setLimitValue(double val){
    _limitValue = val;
    notifyListeners();
  }

  void toggleTransactionAlert(){
    _tAlert = !_tAlert;
    notifyListeners();
  }

  void togglePriceAlert(){
    _pAlert = !_pAlert;
    notifyListeners();
  }

}