import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/data/model/verification_routing.dart';
import 'package:xoecollect/auth/widgets/app_pin.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/models/others/routing_models.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
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
  String otpCode = "";
  VerificationParams? params;

  void timerCount() {
    myTimer = Timer.periodic(Duration(seconds: 1), (time) {
      if (timer > 0)
        setState(() => timer = timer - 1);
      else
        time.cancel();
    });
  }

  @override
  void initState() {
    timerCount();
    setState(() {
      logI(widget.verify_data.data.toJson());
      params = VerificationParams.fromJson(widget.verify_data.data.data);
    });
    super.initState();
  }

  @override
  void dispose() {
    myTimer?.cancel();
    super.dispose();
  }

  resentCode() async {
    setState(() {
      timer = 30;
      otpCode = "";
    });
    controller.clear();
    timerCount();
    AppLoaders.showLoader(dismissOnTap: false, context: context);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: params!.phone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        AppLoaders.dismissEasyLoader();
        AppSheet.appErrorSheet(
            context: context,
            message: "We could not resend the verification code.",
            okAction: () => resentCode(),
            onCancel: () async {
              await LocalPreferences.saveVerificationData(null);
              context.go(AppRoutes.splash);
            });
      },
      codeSent: (String verificationId, int? resendToken) async {
        AppLoaders.dismissEasyLoader();
        final data = VerificationParams(phone: params!.phone, verificationId: verificationId, resendToken: resendToken);
        await LocalPreferences.saveVerificationData(data);
        setState(() {
          params = data;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        logError("codeAutoRetrievalTimeout: $verificationId");
        AppLoaders.dismissEasyLoader();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: kHeight(context),
          alignment: Alignment.center,
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) async {
              if (state is AuthVerifyOTPInit) {
                AppLoaders.showLoader(dismissOnTap: false, context: context);
              }
              if (state is AuthVerifyOTPError) {
                AppLoaders.dismissEasyLoader();
                AppSheet.appErrorSheet(
                  context: context,
                  message: state.res.message,
                  isDismissible: true,
                  onClose: () {},
                  cancelText: "Retry Login",
                  okAction: () {},
                  onCancel: () async {
                    await LocalPreferences.saveVerificationData(null);
                    context.go(AppRoutes.splash);
                  },
                );
              }
              if (state is AuthVerifyOTPSuccess) {
                setState(() => timer = 30);
                AppUser user = state.res;
                await LocalPreferences.saveAllUserInfo(jsonEncode(user.toJson()));
                await LocalPreferences.saveVerificationData(null);
                await LocalPreferences.saveToken(user.token);
                AppLoaders.dismissEasyLoader();
                context.go(AppRoutes.add_pin_screen);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: kAppPadding(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Verify Code", style: Theme.of(context).textTheme.displayMedium),
                      Text("Please enter the verification code that was sent you", textAlign: TextAlign.center),
                      kh20Spacer(),
                      AppPin(
                        controller: controller,
                        onChanged: (pin) {
                          setState(() => otpCode = pin);
                        },
                      ),
                      kh20Spacer(),
                      submitButton(
                        context: context,
                        onPressed: () {
                          if (otpCode.length < 3) {
                            showToastError("Pin must be above 3 characters");
                            return;
                          }
                          BlocProvider.of<AuthCubit>(context).phoneVerification(
                            context: context,
                            phone: widget.verify_data.phone,
                            smsCode: otpCode,
                            verificationId: params!.verificationId,
                          );
                          // context.go(AppRoutes.add_pin_screen);
                        },
                        text: "Verify code",
                      ),
                      khSpacer(50.h),
                      if (timer > 0)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: "Resent code in ",
                            style: Theme.of(context).textTheme.bodySmall,
                            children: <TextSpan>[
                              TextSpan(
                                text: timer.toString() + " seconds",
                                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                              ),
                            ],
                          ),
                        ),
                      if (timer == 0)
                        GestureDetector(
                          onTap: () {
                            resentCode();
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Didn't receive the code? ",
                              style: Theme.of(context).textTheme.bodySmall,
                              children: <TextSpan>[
                                TextSpan(
                                  text: "\nResent now",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
