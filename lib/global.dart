import 'package:coingecko_dart/coingecko_dart.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/controller/connect_controller.dart';
import 'package:cancoin_wallet/controller/sqlite_controller.dart';
import 'package:cancoin_wallet/controller/storageController.dart';
import 'package:cancoin_wallet/controller/web3_controller.dart';
import './controller/color_controller.dart';
import 'controller/color_controller.dart';

final SqliteController sqliteController = SqliteController();
final ColorController color = ColorController();
final ConnectController connectController = ConnectController();
final Web3Controller web3Controller = Get.put(Web3Controller());
final StorageController storageController = StorageController();
final CoinGeckoApi coinGeckoApi = CoinGeckoApi();
