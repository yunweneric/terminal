import 'package:flutter/material.dart';

appShadow(context) {
  return [
    BoxShadow(
      color: Theme.of(context).shadowColor.withOpacity(0.3),
      blurRadius: 12,
      spreadRadius: 2,
    )
  ];
}

appShadowSm(context) {
  return [
    BoxShadow(
      color: Theme.of(context).shadowColor.withOpacity(0.05),
      blurRadius: 2,
      spreadRadius: 3,
    )
  ];
}
