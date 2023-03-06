import 'package:cancoin_wallet/model/notification_info.dart';
import 'package:cancoin_wallet/model/wallet_info.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// id, annotation, date, name, telephone
class SqliteController {
// define tables name
  final String tokenTb = 'tokens_tb';
  final String walletTb = 'wallet_tb';
  final String notifyTb = 'notify_tb';

  final String transactionTb = 'transaction_tb';
  Database?  _db;

  Future<void> open() async {
    if(_db != null) return;
    _db = await openDatabase(
      join(await getDatabasesPath(), 'kingswap.db'),
      onCreate: (db, version)  async {
        db.execute("CREATE TABLE $tokenTb(id INTEGER PRIMARY KEY, logo TEXT, name TEXT, address TEXT, symbol TEXT, tokenId TEXT, chainId INTEGER, isActive INTEGER, state INTEGER)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive, state) VALUES ('https://assets.coingecko.com/coins/images/279/small/ethereum.png?1595348880', 'Ethereum', '', 'eth', 'ethereum', 0, 1, 0)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive, state) VALUES ('https://assets.coingecko.com/coins/images/825/small/binance-coin-logo.png?1547034615', 'Binance Coin', '', 'bnb', 'binancecoin', 1, 1, 0)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive, state) VALUES ('https://assets.coingecko.com/coins/images/11062/small/xdai.png?1614727492', 'xDAI', '', 'xdai', 'xdai', 2, 1, 0)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive, state) VALUES ('https://assets.coingecko.com/coins/images/12623/small/RFUEL_SQR.png?1602481093', 'RioDeFi', '0xaf9f549774ecedbd0966c52f250acc548d3f36e5', 'RFuel', 'rio-defi', 0, 1, 0)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive, state) VALUES ('https://s2.coinmarketcap.com/static/img/coins/64x64/7569.png', 'x\$KING TOKEN', '0xcCd05d20Cc7f1994425Dd21A8939A222D433cD1C', 'x\$KING', 'xking', 2, 1, 0)");
        db.execute("CREATE TABLE $walletTb(id INTEGER PRIMARY KEY, name TEXT, address TEXT, privateKey TEXT)");
        db.execute("CREATE TABLE $notifyTb(id INTEGER PRIMARY KEY, title TEXT, logo TEXT, time TEXT, value TEXT)");
      },
      version: 1,
    );
    return;
  }

  Future<List<TokenInfo>> getTokenList() async {
    List<Map<String, dynamic>> maps = await _db!.query(
      tokenTb,
      orderBy : 'chainId'
    );
    List<TokenInfo> lists = [];

    maps.forEach((token) {
      lists.add(TokenInfo.fromMap(token));
    });
    return lists;
  }

  Future<bool> insertTokenData(TokenInfo token) async {
    final List<Map<String, dynamic>> maps = await _db!.query(
      tokenTb,
      where: "name LIKE ?",
      whereArgs: [token.name]
    ); //rawDelete();
    if(maps.length > 0) return false;

    await _db!.insert(
      tokenTb,
      token.toMap()
    );
    return true;
  }

  Future<bool> updateTokenState(TokenInfo token) async {

    await _db!.update(
      '$tokenTb',
      {
        'state': token.state
      },
      where: "name = ?",
      whereArgs: [token.name],
    );

    return true;
  }

  Future<bool> updateAllState() async {

    await _db!.update(
      '$tokenTb',
      {
        'state': 0
      },
      where: "id > 0"
    );

    return true;
  }

  Future<List<WalletInfo>> getWalletList() async {
    List<Map<String, dynamic>> maps = await _db!.query(
        walletTb
    );
    List<WalletInfo> lists = [];

    maps.forEach((token) {
      lists.add(WalletInfo.fromMap(token));
    });
    return lists;
  }

  Future<bool> insertWalletData(WalletInfo wallet) async {
    final List<Map<String, dynamic>> maps = await _db!.query(
        walletTb,
        where: "privateKey LIKE ?",
        whereArgs: [wallet.privateKey]
    ); //rawDelete();
    if(maps.length > 0) return false;

    await _db!.insert(
        walletTb,
        wallet.toMap()
    );
    return true;
  }

  Future<bool> updateWalletName(String address, String name) async {
    await _db!.update(
      '$walletTb',
      {
        'name': name
      },
      where: "address = ?",
      whereArgs: [address],
    );
    return true;
  }

  Future<bool> deleteWallet(String address) async {
    await _db!.delete(
      '$walletTb',
      where: "address = ?",
      whereArgs: [address]
    );
    return true;
  }

  Future<List<NotificationInfo>> getNotificationList() async {
    List<Map<String, dynamic>> maps = await _db!.query(
        notifyTb
    );
    List<NotificationInfo> lists = [];

    maps.forEach((alert) {
      lists.add(NotificationInfo.fromMap(alert));
    });
    return lists;
  }

  Future<int> insertNotification(NotificationInfo notify) async {
    int newID = await _db!.insert(
        notifyTb,
        notify.toMap()
    );
    return newID;
  }

  Future<bool> deleteNotification(int id) async {
    await _db!.delete(
      '$notifyTb',
      where: "id = ?",
      whereArgs: [id]
    );
    return true;
  }

  Future<bool> clearNotification() async {
    await _db!.delete(
        '$notifyTb',
        where: "id > ?",
        whereArgs: [0]
    );
    return true;
  }

}