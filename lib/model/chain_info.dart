class ChainInfo{
  int id = -1;
  String logo = '';
  String name = '';
  String symbol = '';
  int chainId = 1;

  ChainInfo();

  ChainInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    logo = map['logo'];
    name = map['name'];
    symbol = map['symbol'];
    chainId = map['chainId'];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'logo': logo,
      'name': name,
      'symbol': symbol,
      'chainId' : chainId,
    };
    if (id != -1) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'AuthInfo{id: $id, logo : $logo, name : $name, symbol : $symbol, chainId : $chainId}';
  }


}