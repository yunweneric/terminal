import 'dart:convert';

LoginRequestModel loginRequestModelFromJson(String str) =>
    LoginRequestModel.fromJson(json.decode(str));

String loginRequestModelToJson(LoginRequestModel data) =>
    json.encode(data.toJson());

class LoginRequestModel {
  final String phone;
  final String pin;

  LoginRequestModel({
    required this.phone,
    required this.pin,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      LoginRequestModel(
        phone: json["phone"],
        pin: json["pin"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "pin": pin,
      };
}
