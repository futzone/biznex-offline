class Change {
  String id;
  String database;
  String method;
  String itemId;

  Change({
    required this.id,
    required this.database,
    required this.method,
    required this.itemId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'database': database,
      'method': method,
      'itemId': itemId,
    };
  }

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      id: json['id'],
      database: json['database'],
      method: json['method'],
      itemId: json['itemId'],
    );
  }
}
