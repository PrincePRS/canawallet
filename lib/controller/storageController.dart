import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class StorageController{
  SharedPreferences? _instance;

  SharedPreferences? get instance => _instance;

  StorageController(){
    // getInstance();
  }

  Future<void> getInstance() async{
    _instance = await SharedPreferences.getInstance();
  }


}