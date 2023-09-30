// To parse this JSON data, do
//
//     final updateProfileReq = updateProfileReqFromJson(jsonString);

import 'dart:convert';

class UpdateProfileReq {
  final String userName;
  final String firstName;
  final String lastName;
  final String avatar;
  final String email;
  final String address;
  final String genre;

  UpdateProfileReq({
    required this.userName,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.email,
    required this.address,
    required this.genre,
  });

  factory UpdateProfileReq.fromRawJson(String str) => UpdateProfileReq.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UpdateProfileReq.fromJson(Map<String, dynamic> json) => UpdateProfileReq(
        userName: json["user_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        avatar: json["avatar"],
        email: json["email"],
        address: json["address"],
        genre: json["genre"],
      );

  Map<String, dynamic> toJson() => {
        "user_name": userName,
        "first_name": firstName,
        "last_name": lastName,
        "avatar": avatar,
        "email": email,
        "address": address,
        "genre": genre,
      };
}
