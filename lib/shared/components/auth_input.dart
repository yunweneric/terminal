import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

Widget authInput({
  String? label,
  required String hint,
  required BuildContext context,
  Widget? prefixIcon,
  Widget? sufficIcon,
  int? maxLines,
  TextInputType? keyboardType,
  bool obscureText = false,
  TextEditingController? controller,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
  EdgeInsetsGeometry? contentPadding,
  bool readOnly = false,
  double? width,
  TextStyle? hintStyle,
}) {
  return Container(
    margin: kPadding(0, 10.h),
    width: width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label),
        if (label != null) khSpacer(5.h),
        TextFormField(
          readOnly: readOnly,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          onChanged: onChanged,
          validator: validator,
          style: Theme.of(context).textTheme.bodyMedium,
          obscureText: obscureText,
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon,
            suffixIcon: sufficIcon,
            hintStyle: hintStyle ?? Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).highlightColor.withOpacity(0.9)),
            contentPadding: contentPadding,
          ),
        ),
      ],
    ),
  );
}
