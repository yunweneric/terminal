import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/theme/colors.dart';

AppBar appBar({
  required BuildContext context,
  Color? color,
  Color? bgColor,
  required String title,
  bool? canPop,
  bool? centerTitle,
  PreferredSizeWidget? bottom,
  TextStyle? style,
}) {
  return AppBar(
    backgroundColor: bgColor ?? Theme.of(context).primaryColor,
    centerTitle: centerTitle,
    title: Text(title, style: style ?? TextStyle(color: color ?? kWhite)),
    automaticallyImplyLeading: canPop == true ? true : false,
    leading: canPop == true
        ? GestureDetector(
            onTap: canPop == true ? () => context.pop() : null,
            child: Icon(Icons.arrow_back, color: color ?? kWhite),
          )
        : null,
    bottom: bottom,
  );
}
