import 'dart:convert';

RegisterRequestModel registerRequestModelFromJson(String str) => RegisterRequestModel.fromJson(json.decode(str));

String registerRequestModelToJson(RegisterRequestModel data) => json.encode(data.toJson());

class RegisterRequestModel {
  final String phone;
  final String email;
  final String role;
  final String username;

  RegisterRequestModel({
    required this.phone,
    required this.role,
    required this.username,
    required this.email,
  });

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => RegisterRequestModel(
        phone: json["phone"],
        email: json["email"],
        role: json["role"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "role": role,
        "email": email,
        "username": username,
      };
}
