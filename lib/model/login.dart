// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  String? status;
  Data? data;

  Login({
    required this.status,
    required this.data,
  });

  factory Login.fromJson(Map<String, dynamic> json) => Login(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  String? message;
  String? token;
  String? type;
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? roles;

  Data({
    required this.message,
    required this.token,
    required this.type,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.roles,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    token: json["token"],
    type: json["type"],
    id: json["id"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    roles: json["roles"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "type": type,
    "id": id,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "roles": roles,
  };
}
