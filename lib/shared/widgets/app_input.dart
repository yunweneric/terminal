import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ez_trip/shared/components/radius.dart';

InputDecoration authInputDecoration({required String hintText, required BuildContext context, label, prefixIcon, suffix}) {
  return InputDecoration(
    hintText: hintText,
    labelText: label ?? hintText,
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 0.0),
    border: mainBorder(),
    focusedBorder: mainfocusBorder(),
    errorBorder: errorBorder(),
    focusedErrorBorder: errorBorder(),
    hintStyle: Theme.of(context).textTheme.bodyMedium,

    prefixIcon: Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 0),
      child: prefixIcon,
    ),
    // suffix: suffix,
    // suffixText: suffix,
    // suffixStyle: TextStyle(color: kPBlueColor, fontSize: 14.sp),
  );
}

OutlineInputBorder mainBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: radiusSm(),
  );
}

OutlineInputBorder mainfocusBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: radiusSm(),
  );
}

OutlineInputBorder errorBorder() {
  return OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: radiusSm(),
  );
}
