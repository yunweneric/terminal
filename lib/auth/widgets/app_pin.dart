import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:xoecollect/shared/components/radius.dart';

class AppPin extends StatefulWidget {
  final void Function(String)? onChanged;
  final int? length;
  const AppPin({super.key, this.onChanged, this.length});

  @override
  State<AppPin> createState() => _AppPinState();
}

class _AppPinState extends State<AppPin> {
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60.w,
      height: 60.w,
      textStyle: TextStyle(fontSize: 20.sp, color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: radiusSm(),
        color: Theme.of(context).highlightColor,
      ),
    );
    return Pinput(
      length: widget.length ?? 6,
      // controller: controller,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      errorText: null,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
      autofocus: true,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: defaultPinTheme.copyDecorationWith(
        border: Border.all(color: Theme.of(context).primaryColor),
        borderRadius: radiusSm(),
      ),
      submittedPinTheme: defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: Theme.of(context).cardColor,
        ),
      ),
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onChanged: widget.onChanged,
    );
  }
}
