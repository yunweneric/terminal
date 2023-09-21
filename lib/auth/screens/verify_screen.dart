import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/screens/app_pin.dart';
import 'package:xoecollect/shared/models/others/routing_models.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class VerifyScreen extends StatefulWidget {
  final VerificationRoutingModel verify_data;
  const VerifyScreen({super.key, required this.verify_data});

  @override
  State<VerifyScreen> createState() => _RegisterState();
}

class _RegisterState extends State<VerifyScreen> {
  Timer? myTimer;
  int timer = 30;
  int redirect_time = 5;
  bool loading = false;
  bool error = false;
  TextEditingController controller = TextEditingController();
  void timerCount() {
    myTimer = Timer.periodic(Duration(seconds: 1), (time) {
      if (timer > 0)
        setState(() => timer = timer - 1);
      else
        time.cancel();
    });
  }

  void start_redirect_timer() {
    myTimer = Timer.periodic(Duration(seconds: 1), (time) {
      if (redirect_time > 0)
        setState(() => redirect_time = redirect_time - 1);
      else
        time.cancel();
    });
  }

  void resetTimer() {
    setState(() => timer = 30);
    timerCount();
  }

  @override
  void initState() {
    timerCount();
    super.initState();
  }

  String otpCode = "";
  @override
  void dispose() {
    myTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: kHeight(context),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: kAppPadding(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Verify Code", style: Theme.of(context).textTheme.displayLarge),
                  Text("Please enter the verification code that was sent you", textAlign: TextAlign.center),
                  kh20Spacer(),
                  AppPin(
                    onChanged: (pin) {
                      setState(() => otpCode = pin);
                    },
                  ),
                  kh20Spacer(),
                  submitButton(
                    width: isMobile(kWidth(context)) ? kWidth(context) : kWidth(context) / 2,
                    context: context,
                    onPressed: () {
                      if (otpCode.length < 3) {
                        showToastError("Pin must be above 3 characters");
                        return;
                      }
                      context.go(AppRoutes.add_pin_screen);
                    },
                    text: "Verify code",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget authInput({
    required String label,
    required String hint,
    Widget? prefixIcon,
    Widget? sufficIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      margin: kPadding(0, 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          khSpacer(5.h),
          TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            obscureText: obscureText,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon,
              suffixIcon: sufficIcon,
              hintStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
