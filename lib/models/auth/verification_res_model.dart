// To parse this JSON data, do
//
//     final verificationResponseModel = verificationResponseModelFromJson(jsonString);

import 'dart:convert';

VerificationResponseModel verificationResponseModelFromJson(String str) =>
    VerificationResponseModel.fromJson(json.decode(str));

String verificationResponseModelToJson(VerificationResponseModel data) =>
    json.encode(data.toJson());

class VerificationResponseModel {
  final int code;
  final String message;
  final Data data;

  VerificationResponseModel({
    required this.code,
    required this.message,
    required this.data,
  });

  factory VerificationResponseModel.fromJson(Map<String, dynamic> json) =>
      VerificationResponseModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  final String token;
  final Account account;

  Data({
    required this.token,
    required this.account,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        account: Account.fromJson(json["account"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "account": account.toJson(),
      };
}

class Account {
  final String uuid;
  final DateTime createdAt;
  final String? email;
  final String username;
  final String phone;
  final Role role;
  final Details details;

  Account({
    required this.uuid,
    required this.createdAt,
    this.email,
    required this.username,
    required this.phone,
    required this.role,
    required this.details,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        uuid: json["uuid"],
        createdAt: DateTime.parse(json["created_at"]),
        email: json["email"],
        username: json["username"],
        phone: json["phone"],
        role: Role.fromJson(json["role"]),
        details: Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "created_at": createdAt.toIso8601String(),
        "email": email,
        "username": username,
        "phone": phone,
        "role": role.toJson(),
        "details": details.toJson(),
      };
}

class Details {
  final String uuid;
  final DateTime createdAt;
  final String firstName;
  final String lastName;
  final dynamic function;
  final dynamic avatar;
  final dynamic countryCode;
  final dynamic countryName;
  final dynamic regionName;
  final dynamic genre;

  Details({
    required this.uuid,
    required this.createdAt,
    required this.firstName,
    required this.lastName,
    this.function,
    this.avatar,
    this.countryCode,
    this.countryName,
    this.regionName,
    this.genre,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        uuid: json["uuid"],
        createdAt: DateTime.parse(json["created_at"]),
        firstName: json["first_name"],
        lastName: json["last_name"],
        function: json["function"],
        avatar: json["avatar"],
        countryCode: json["countryCode"],
        countryName: json["countryName"],
        regionName: json["regionName"],
        genre: json["genre"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "created_at": createdAt.toIso8601String(),
        "first_name": firstName,
        "last_name": lastName,
        "function": function,
        "avatar": avatar,
        "countryCode": countryCode,
        "countryName": countryName,
        "regionName": regionName,
        "genre": genre,
      };
}

class Role {
  final String uuid;
  final DateTime createdAt;
  final String name;
  final String description;

  Role({
    required this.uuid,
    required this.createdAt,
    required this.name,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        uuid: json["uuid"],
        createdAt: DateTime.parse(json["created_at"]),
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "created_at": createdAt.toIso8601String(),
        "name": name,
        "description": description,
      };
}
