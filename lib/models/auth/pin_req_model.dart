import 'dart:convert';

PinReqModel PinReqModelFromJson(String str) =>
    PinReqModel.fromJson(json.decode(str));

String PinReqModelToJson(PinReqModel data) => json.encode(data.toJson());

class PinReqModel {
  final String old_pin;
  final String new_pin;

  PinReqModel({
    required this.old_pin,
    required this.new_pin,
  });

  factory PinReqModel.fromJson(Map<String, dynamic> json) => PinReqModel(
        old_pin: json["old_pin"],
        new_pin: json["new_pin"],
      );

  Map<String, dynamic> toJson() => {
        "old_pin": old_pin,
        "new_pin": new_pin,
      };
}
