import 'dart:async';
import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:coingecko_dart/dataClasses/coins/PricedCoin.dart';
import 'package:coingecko_dart/dataClasses/coins/SimpleToken.dart';
import 'package:flutter/cupertino.dart';
import 'package:cancoin_wallet/constants/chains.dart';
import 'package:cancoin_wallet/constants/strings.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:cancoin_wallet/model/transaction_info.dart';
import 'package:web3dart/web3dart.dart';

class TransactionProvider extends ChangeNotifier{
  List<TokenInfo> _transactions = [];

  List<TokenInfo> get transactions => _transactions;

  TransactionProvider(){

  }

}