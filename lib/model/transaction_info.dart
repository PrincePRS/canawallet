class TransactionInfo {
  // int? id = -1;
  String hash = '';
  bool isSent = true;
  String receiver = '';
  int status = 0;
  int nonce = 0;
  double fee = 0;
  double value = 0;
  String date = '';
  TransactionInfo();

  TransactionInfo.fromMap(Map<String, dynamic> map) {
    // id = map['id'];
    hash = map['hash'];
    isSent = map['isSent'];
    receiver = map['receiver'];
    status = map['status'];
    nonce = map['nonce'];
    fee = map['fee'];
    value = map['value'];
    date = map['date'];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'hash': hash,
      'isSent': isSent,
      'receiver': receiver,
      'status': status,
      'nonce' : nonce,
      'fee' : fee,
      'value' : value,
      'date' : date
    };
    // if (id != -1) {
    //   map['id'] = id;
    // }
    return map;
  }

  @override
  String toString() {
    return 'TransactionInfo{isSent : $isSent, receiver : $receiver, value: $value, status : $status, nonce : $nonce, fee: $fee, date: $date, hash: $hash}';
  }
}