class WalletInfo {
  int? id = -1;
  String name = '';
  String address = '';
  String privateKey = '';

  WalletInfo();

  WalletInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    address = map['address'];
    privateKey = map['privateKey'];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'name': name,
      'address': address,
      'privateKey': privateKey
    };
    if (id != -1) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'WalletInfo{id: $id, name : $name, address : $address, privateKey : $privateKey}';
  }
}