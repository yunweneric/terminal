import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/theme/colors.dart';

/// PinCodeField
class PinCodeField extends StatelessWidget {
  const PinCodeField({
    Key? key,
    required this.pin,
    required this.pinCodeFieldIndex,
    required this.theme,
  }) : super(key: key);

  /// The pin code
  final String pin;

  /// The the index of the pin code field
  final PinTheme theme;

  /// The index of the pin code field
  final int pinCodeFieldIndex;

  Color get getFillColorFromIndex {
    if (pin.length > pinCodeFieldIndex) {
      return primaryColor;
    } else if (pin.length == pinCodeFieldIndex) {
      return kGrey.withOpacity(0.2);
    }
    return kGrey.withOpacity(0.2);
  }

  Color get getFillBorderColorFromIndex {
    if (pin.length > pinCodeFieldIndex) {
      return primaryColor;
    } else if (pin.length == pinCodeFieldIndex) {
      return kGrey.withOpacity(0.2);
    }
    return kGrey.withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 50.h,
      width: 50.h,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(5.r),
        shape: BoxShape.rectangle,
        border: Border.all(color: getFillColorFromIndex, width: 1),
      ),
      duration: const Duration(microseconds: 40000),
      child: pin.length > pinCodeFieldIndex
          ? Icon(
              Icons.circle,
              color: Theme.of(context).primaryColorDark,
              size: 15.r,
            )
          : const SizedBox(),
    );
  }
}
