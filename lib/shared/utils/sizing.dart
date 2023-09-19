import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

EdgeInsetsGeometry kAppPadding() => EdgeInsets.symmetric(horizontal: 20.w);
EdgeInsetsGeometry kph(double size) => EdgeInsets.symmetric(horizontal: size);

EdgeInsetsGeometry kPadding(double width, double height) => EdgeInsets.symmetric(horizontal: width, vertical: height);

EdgeInsetsGeometry kpv(double size) => EdgeInsets.symmetric(vertical: size);

double kWidth(context) => MediaQuery.of(context).size.width;

double kHeight(context) => MediaQuery.of(context).size.height;

Widget kh20Spacer() => SizedBox(height: 20.h);
Widget kh10Spacer() => SizedBox(height: 10.h);

Widget khSpacer(double height) => SizedBox(height: height);

Widget kwSpacer(double width) => SizedBox(width: width);

bool isMobile(width) => width > 600 ? false : true;
bool isDesktop(width) => width > 600 ? true : false;
