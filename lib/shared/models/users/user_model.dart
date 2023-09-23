// To parse this JSON data, do
//
//     final appUser = appUserFromJson(jsonString);

import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/models/auth/providers.dart';

AppUser appUserFromJson(String str) => AppUser.fromJson(json.decode(str));

String appUserToJson(AppUser data) => json.encode(data.toJson());

class AppUser {
  AppUser({
    this.username,
    this.password,
    required this.uid,
    this.email,
    this.emailVerified,
    required this.phoneNumber,
    this.photoUrl,
    required this.providerId,
    required this.created_at,
    required this.token,
    required this.nToken,
    required this.role,
  });

  final String? username;
  final String created_at;
  final String uid;
  final String? email;
  final String? emailVerified;
  final String phoneNumber;
  final String? photoUrl;
  String? password;
  final String providerId;
  final String token;
  final AppRole role;
  final List<String> nToken;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        username: json["username"],
        uid: json["uid"],
        password: json["password"],
        email: json["email"],
        emailVerified: json["emailVerified"],
        phoneNumber: json["phoneNumber"],
        photoUrl: json["photoURL"],
        providerId: json["providerId"],
        created_at: json["created_at"],
        role: AppRole.fromJson(json["role"]),
        token: json["token"],
        nToken: List<String>.from(json["nToken"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "password": password,
        "emailVerified": emailVerified,
        "phoneNumber": phoneNumber,
        "photoURL": photoUrl,
        "providerId": providerId,
        "created_at": created_at,
        "token": token,
        "role": role.toJson(),
        "nToken": List<String>.from(nToken.map((x) => x)),
      };

  static AppUser empty() {
    return AppUser(
      uid: "",
      created_at: "",
      email: "",
      username: "",
      phoneNumber: "",
      photoUrl: "",
      role: AppRole(role: "", value: ""),
      providerId: '',
      token: '',
      nToken: [],
    );
  }

  static AppUser fake() {
    Faker faker = Faker();
    return AppUser(
      uid: Uuid().v1(),
      created_at: DateTime.now().toIso8601String(),
      email: faker.internet.email(),
      username: faker.person.name(),
      phoneNumber: faker.phoneNumber.us(),
      photoUrl: faker.image.image(),
      role: AppRole(role: "agent", value: Uuid().v1()),
      providerId: AuthProviders.PHONE,
      token: '',
      nToken: [],
    );
  }
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
