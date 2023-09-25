import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class PinAuthScreen extends StatefulWidget {
  const PinAuthScreen({super.key});

  @override
  State<PinAuthScreen> createState() => _PinAuthScreenState();
}

class _PinAuthScreenState extends State<PinAuthScreen> {
  bool loading = false;
  bool error = false;
  String otpCode = "";
  List values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
  PinInputController pinInputController = PinInputController(length: 4);

  /// very important

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: kHeight(context),
          width: kWidth(context),
          padding: kAppPadding(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: kHeight(context) * 0.05,
              ),
              PinPlusKeyBoardPackage(
                keyboardFontFamily: "Helvetica",
                spacing: kWidth(context) * 0.06,
                // inputShape: InputShape.circular,
                pinInputController: pinInputController,
                btnHasBorder: false,
                inputsMaxWidth: 100.w,
                inputWidth: 60.w,
                inputHasBorder: false,
                inputFillColor: Theme.of(context).highlightColor.withOpacity(0.3),
                // inputBorderRadius: radiusVal(2.r),
                focusColor: Theme.of(context).primaryColor,
                isInputHidden: true,
                inputHiddenColor: Theme.of(context).primaryColor.withOpacity(0.2),
                inputTextStyle: TextStyle(),
                onSubmit: () {
                  /// ignore: avoid_print
                  print("Text is : " + pinInputController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
