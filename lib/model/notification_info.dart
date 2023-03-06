class NotificationInfo {
  int? id = -1;
  String title = '';
  String logo = '';
  String time = '';
  String value = '';

  NotificationInfo();

  NotificationInfo.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    logo = map['logo'];
    time = map['time'];
    value = map['value'];
  }

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      'title': title,
      'logo': logo,
      'time': time,
      'value': value
    };
    if (id != -1) {
      map['id'] = id;
    }
    return map;
  }

  @override
  String toString() {
    return 'NotifyInfo{id: $id, title : $title, logo : $logo, time : $time, value : $value}';
  }
}