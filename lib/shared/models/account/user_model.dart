import 'dart:convert';

class AppUser {
  final String uuid;
  final DateTime createdAt;
  final String email;
  final String photoUrl;
  final String username;
  final String phone;
  final Role role;

  AppUser({
    required this.uuid,
    required this.createdAt,
    required this.email,
    required this.username,
    required this.phone,
    required this.photoUrl,
    required this.role,
  });

  factory AppUser.fromRawJson(String str) => AppUser.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        uuid: json["uuid"],
        createdAt: DateTime.parse(json["created_at"]),
        photoUrl: json["photoUrl"],
        email: json["email"],
        username: json["username"],
        phone: json["phone"],
        role: Role.fromJson(json["role"]),
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "created_at": createdAt.toIso8601String(),
        "email": email,
        "photoUrl": photoUrl,
        "username": username,
        "phone": phone,
        "role": role.toJson(),
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

  factory Role.fromRawJson(String str) => Role.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

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
