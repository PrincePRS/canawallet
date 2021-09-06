import 'package:http/http.dart';
import 'package:cancoin_wallet/model/token_info.dart';
import 'package:cancoin_wallet/model/transaction_info.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// id, annotation, date, name, telephone
class SqliteController {
// define tables name
  final String tokenTb = 'tokens_tb';
  final String transactionTb = 'transaction_tb';
  Database?  _db;

  Future<void> open() async {
    if(_db != null) return;
    _db = await openDatabase(
      join(await getDatabasesPath(), 'kingswap.db'),
      onCreate: (db, version)  async {
        db.execute("CREATE TABLE $tokenTb(id INTEGER PRIMARY KEY, logo TEXT, name TEXT, address TEXT, symbol TEXT, tokenId TEXT, chainId INTEGER, isActive INTEGER)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive) VALUES ('https://assets.coingecko.com/coins/images/279/small/ethereum.png?1595348880', 'Ethereum', '', 'eth', 'ethereum', 0, 1)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive) VALUES ('https://assets.coingecko.com/coins/images/825/small/binance-coin-logo.png?1547034615', 'Binance Coin', '', 'bnb', 'binancecoin', 1, 1)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive) VALUES ('https://assets.coingecko.com/coins/images/11062/small/xdai.png?1614727492', 'xDAI', '', 'xdai', 'xdai', 2, 1)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive) VALUES ('https://assets.coingecko.com/coins/images/12623/small/RFUEL_SQR.png?1602481093', 'RioDeFi', '0xaf9f549774ecedbd0966c52f250acc548d3f36e5', 'RFuel', 'rio-defi', 0, 1)");
        await db.rawInsert("INSERT INTO $tokenTb (logo, name, address, symbol, tokenId, chainId, isActive) VALUES ('https://s2.coinmarketcap.com/static/img/coins/64x64/7569.png', 'x\$KING TOKEN', '0xcCd05d20Cc7f1994425Dd21A8939A222D433cD1C', 'x\$KING', 'xking', 2, 1)");

        // db.execute("CREATE TABLE $transactionTb(id INTEGER PRIMARY KEY, hash TEXT, from TEXT, to TEXT, nonce INTEGER, tokenId INTEGER, status INTEGER, fee REAL, value REAL, date TEXT)");
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

  // Future<List<TransactionInfo>> getTransactionList(String address, String tokenId) async {
  //   List<Map<String, dynamic>> maps = await _db!.query(
  //     transactionTb,
  //     where: 'tokenId = ?',
  //     whereArgs: [address, tokenId],
  //     orderBy : 'tokenId'
  //   );
  //
  //   List<TransactionInfo> lists = [];
  //
  //   maps.forEach((tx) {
  //     bool isSent = false;
  //
  //     if(tx['from'] == address || tx['to'] == address){
  //       if(tx['from'] == address){
  //         isSent = true;
  //       } else {
  //         isSent = false;
  //       }
  //
  //       lists.add(TransactionInfo.fromMap({
  //         'hash'     :  tx['hash'],
  //         'isSent'   :  isSent,
  //         'receiver' :  isSent ? tx['to'] : tx['from'],
  //         'status'   :  tx['status'],
  //         'nonce'    :  tx['nonce'],
  //         'fee'      :  tx['fee'],
  //         'value'    :  tx['value'],
  //         'date'     :  tx['date']
  //       }));
  //     }
  //   });
  //   return lists;
  // }
  //
  // Future<bool> insertTransactionData(TokenInfo token) async {
  //
  //   final List<Map<String, dynamic>> maps = await _db!.query(
  //     transactionTb,
  //     where: "name LIKE ?",
  //     whereArgs: [token.name]
  //   ); // rawDelete();
  //
  //   if(maps.length > 0) return false;
  //
  //   await _db!.insert(
  //     transactionTb,
  //     token.toMap()
  //   );
  //   return true;
  // }
}