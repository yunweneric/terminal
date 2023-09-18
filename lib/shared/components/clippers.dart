import 'package:flutter/material.dart';

class AppCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height;
    final path = Path();
    path.moveTo(0, h / 4);
    path.lineTo(0, h);
    path.lineTo(w, h);
    path.lineTo(w, h / 4);
    path.quadraticBezierTo(w * 0.5, -(h / 200), 0, h / 4);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // throw UnimplementedError();
    return true;
  }
}
