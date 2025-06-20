class Change {
  String id;
  String database;
  String method;
  String itemId;
  String data;

  Change({
    this.id = '',
    required this.database,
    required this.method,
    required this.itemId,
    this.data = '',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'database': database,
      'method': method,
      'itemId': itemId,
      'data': data,
    };
  }

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      id: json['id'],
      database: json['database'],
      method: json['method'],
      itemId: json['itemId'],
      data: json['data'],
    );
  }
}
