import 'dart:convert';

class DbModel {
  final int? createdAt;
  final dynamic createdBy;
  final dynamic updatedBy;
  final int? updatedAt;
  final dynamic accountId;
  final int? id;
  String? db_name;
  String? db_username;
  String db_password;
  int port_no;
  String? host_name;
  String? techstack;
  bool? existing_db;

  final String? moduleId;
  final dynamic description;

  DbModel({
    this.createdAt,
    this.createdBy,
    this.updatedBy,
    this.updatedAt,
    this.accountId,
    this.id,
    this.db_name,
    this.db_username,
    required this.db_password,
    required this.port_no,
    this.host_name,
    this.techstack,
    this.existing_db,
    this.moduleId,
    this.description,
  });

  factory DbModel.fromRawJson(String str) => DbModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DbModel.fromJson(Map<String, dynamic> json) => DbModel(
        createdAt: json["createdAt"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        updatedAt: json["updatedAt"],
        accountId: json["accountId"],
        id: json["id"],
        db_name: json['db_name'],
        db_username: json['db_username'],
        db_password: json['db_password'],
        port_no: json['port_no'],
        host_name: json['host_name'],
        techstack: json['techstack'],
        existing_db: json['existing_db'],
        moduleId: json["module_id"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "createdAt": createdAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "updatedAt": updatedAt,
        "accountId": accountId,
        "id": id,
        "techstack": techstack,
        "module_id": moduleId,
        "description": description,
        "db_name": db_name,
        "db_password": db_password,
        "port_no": port_no,
        "db_username": db_username,
        "existing_db": existing_db,
        "host_name": host_name,
      };
}
