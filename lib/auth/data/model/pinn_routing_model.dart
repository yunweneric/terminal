import 'package:flutter/material.dart';

class PinRoutingModel {
  final Function(String, BuildContext?) onComplete;
  final Function(BuildContext?)? onVerified;
  final VoidCallback? onSpecialKeyPress;
  final String? title;

  PinRoutingModel({this.onVerified, this.title, required this.onComplete, this.onSpecialKeyPress});
}
