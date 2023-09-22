// To parse this JSON data, do
//
//     final verificationParams = verificationParamsFromJson(jsonString);

import 'dart:convert';

VerificationParams verificationParamsFromJson(String str) => VerificationParams.fromJson(json.decode(str));

String verificationParamsToJson(VerificationParams data) => json.encode(data.toJson());

class VerificationParams {
  final String phone;
  final String verificationId;
  final int? resendToken;

  VerificationParams({
    required this.phone,
    required this.verificationId,
    this.resendToken,
  });

  factory VerificationParams.fromJson(Map<String, dynamic> json) => VerificationParams(
        phone: json["phone"],
        verificationId: json["verificationId"],
        resendToken: json["resendToken"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "verificationId": verificationId,
        "resendToken": resendToken,
      };
}
