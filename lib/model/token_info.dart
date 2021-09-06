class TokenInfo {
  int? id = -1;
  String logo = '';
  String name = '';
  String address = '';
  String symbol = '';
  String tokenId = '';
  int chainId = 1;
  double price = 0;
  double change = 0;
  double balance = 0;
  bool isActive = false;

  TokenInfo();

  TokenInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    logo = map['logo'];
    name = map['name'];
    address = map['address'];
    symbol = map['symbol'];
    chainId = map['chainId'];
    tokenId = map['tokenId'];
    isActive = map['isActive'] == 1;
    price = map['price'] == null ? 0 : map['price'];
    change = map['change'] == null ? 0 : map['change'];
    balance = map['balance'] == null ? 0 : map['balance'];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'logo': logo,
      'name': name,
      'address': address,
      'symbol': symbol,
      'chainId' : chainId,
      'tokenId' : tokenId,
      'isActive' : isActive ? 1 : 0
    };
    if (id != -1) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'AuthInfo{id: $id, logo : $logo, name : $name, address : $address, symbol : $symbol, tokenId: $tokenId, chainId : $chainId, isActive : $isActive}';
  }


}