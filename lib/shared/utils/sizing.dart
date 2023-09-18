import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

EdgeInsetsGeometry kAppPading() => EdgeInsets.symmetric(horizontal: 20.w);
EdgeInsetsGeometry kph(double size) => EdgeInsets.symmetric(horizontal: size);

EdgeInsetsGeometry kpadding(double width, double height) => EdgeInsets.symmetric(horizontal: width, vertical: height);

EdgeInsetsGeometry kpv(double size) => EdgeInsets.symmetric(vertical: size);

double kwidth(context) => MediaQuery.of(context).size.width;

double kheight(context) => MediaQuery.of(context).size.height;

Widget kh20Spacer() => SizedBox(height: 20.h);
Widget kh10Spacer() => SizedBox(height: 10.h);

Widget khSpacer(double height) => SizedBox(height: height);

Widget kwSpacer(double width) => SizedBox(width: width);
