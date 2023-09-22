// To parse this JSON data, do
//
//     final appUser = appUserFromJson(jsonString);

import 'dart:convert';

AppUser appUserFromJson(String str) => AppUser.fromJson(json.decode(str));

String appUserToJson(AppUser data) => json.encode(data.toJson());

class AppUser {
  AppUser({
    this.username,
    required this.uid,
    required this.email,
    this.emailVerified,
    this.phoneNumber,
    this.photoUrl,
    this.ref_id,
    required this.providerId,
    required this.created_at,
    required this.updated_at,
    this.token,
    required this.nToken,
    required this.role,
    required this.souls,
    required this.points,
    this.date_of_birth,
  });

  final String? username;
  final String? ref_id;
  final String uid;
  final String email;
  final String? emailVerified;
  final String? phoneNumber;
  final String? photoUrl;
  final String providerId;
  final String? token;
  final AppRole role;
  final List<String> souls;
  final int points;
  final List<String> nToken;
  final DateTime created_at;
  final DateTime updated_at;
  final DateTime? date_of_birth;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        username: json["username"],
        uid: json["uid"],
        email: json["email"],
        ref_id: json["ref_id"],
        emailVerified: json["emailVerified"],
        phoneNumber: json["phoneNumber"],
        photoUrl: json["photoURL"],
        providerId: json["providerId"],
        created_at: DateTime.parse(json["created_at"]),
        updated_at: DateTime.parse(json["updated_at"]),
        date_of_birth: json["date_of_birth"],
        role: AppRole.fromJson(json["role"]),
        token: json["token"],
        nToken: List<String>.from(json["nToken"]!.map((x) => x)),
        souls: List<String>.from(json["souls"]!.map((x) => x)),
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "ref_id": ref_id,
        "email": email,
        "emailVerified": emailVerified,
        "phoneNumber": phoneNumber,
        "photoURL": photoUrl,
        "providerId": providerId,
        "created_at": created_at.toIso8601String(),
        "updated_at": updated_at.toIso8601String(),
        "date_of_birth": date_of_birth?.toIso8601String(),
        "token": token,
        "role": role.toJson(),
        "nToken": List<String>.from(nToken.map((x) => x)),
        "souls": List<String>.from(souls.map((x) => x)),
        "points": points,
      };
}

class AppRole {
  AppRole({
    required this.role,
    this.value,
  });

  final String role;
  final String? value;

  factory AppRole.fromJson(Map<String, dynamic> json) => AppRole(
        role: json["role"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "value": value,
      };
}
