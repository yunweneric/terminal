// To parse this JSON data, do
//
//     final resetPinReqModel = resetPinReqModelFromJson(jsonString);

import 'dart:convert';

ResetPinReqModel resetPinReqModelFromJson(String str) =>
    ResetPinReqModel.fromJson(json.decode(str));

String resetPinReqModelToJson(ResetPinReqModel data) =>
    json.encode(data.toJson());

class ResetPinReqModel {
  final String oldPin;
  final String newPin;

  ResetPinReqModel({
    required this.oldPin,
    required this.newPin,
  });

  factory ResetPinReqModel.fromJson(Map<String, dynamic> json) =>
      ResetPinReqModel(
        oldPin: json["old_pin"],
        newPin: json["new_pin"],
      );

  Map<String, dynamic> toJson() => {
        "old_pin": oldPin,
        "new_pin": newPin,
      };
}
