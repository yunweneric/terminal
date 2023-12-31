import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

Widget submitButton(
    {required BuildContext context,
    required VoidCallback onPressed,
    required String text,
    Color? color,
    Color? textColor,
    EdgeInsetsGeometry? padding,
    BorderRadiusGeometry? borderRadius,
    double? width,
    double? elevation,
    BorderSide? borderSide,
    double? height,
    double? fontSize,
    Widget? icon,
    bool animate = true,
    bool loading = false,
    bool isReversed = false}) {
  return SizedBox(
    width: width == null ? kWidth(context) : width,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: borderRadius ?? radiusXxl(), side: borderSide == null ? BorderSide.none : borderSide),
        padding: padding ?? EdgeInsets.symmetric(vertical: 20.h),
        backgroundColor: color ?? Theme.of(context).primaryColor,
        elevation: elevation == null ? 0 : elevation,
      ),
      onPressed: loading ? () {} : onPressed,
      child: loading
          ? CupertinoActivityIndicator()
          : icon == null
              ? Text(
                  text,
                  style: TextStyle(fontSize: fontSize ?? 12.sp, color: textColor ?? kWhite),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: isReversed
                      ? [
                          Text(
                            text,
                            style: TextStyle(fontSize: fontSize ?? 12.w, color: textColor, fontWeight: FontWeight.w700),
                          ),
                          if (text != "") kwSpacer(10.w),
                          icon,
                        ]
                      : [
                          icon,
                          if (text != "") SizedBox(width: 10.w),
                          Text(
                            text,
                            style: TextStyle(fontSize: fontSize ?? 12.w, color: textColor, fontWeight: FontWeight.w700),
                          ),
                        ],
                ),
    ),
  );
}
