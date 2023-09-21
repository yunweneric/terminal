import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/screens/app_pin.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/modals.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class AddPinScreen extends StatefulWidget {
  final bool fromSplashScreen;
  const AddPinScreen({super.key, required this.fromSplashScreen});

  @override
  State<AddPinScreen> createState() => _AddPinScreenState();
}

class _AddPinScreenState extends State<AddPinScreen> {
  bool loading = false;
  bool error = false;
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: appBar(context: context, title: "Add Pin", canPop: false),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          height: kHeight(context),
          width: kWidth(context),
          padding: kAppPadding(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Image.asset(ImageAssets.logo_and_name, scale: 2)),
                kh20Spacer(),
                Text("Add your account pin", style: Theme.of(context).textTheme.displayMedium),
                kh20Spacer(),
                Text(
                  "You will use this pin to login once your account is created!",
                  textAlign: TextAlign.center,
                ),
                kh20Spacer(),
                AppPin(
                  onChanged: (pin) {
                    setState(() => otpCode = pin);
                  },
                ),
                kh20Spacer(),
                submitButton(
                  loading: loading,
                  context: context,
                  color: otpCode.length > 3 ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
                  textColor: otpCode.length > 3 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark,
                  onPressed: otpCode.length < 3
                      ? () {}
                      : () => showDialog(
                            useSafeArea: false,
                            context: context,
                            builder: (BuildContext context) {
                              return BlocProvider(create: (context) => AuthCubit(), child: ConfirmPin(code: otpCode));
                            },
                          ),
                  text: "Continue",
                ),
                kh20Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmPin extends StatefulWidget {
  final String code;
  ConfirmPin({super.key, required this.code});

  @override
  State<ConfirmPin> createState() => _ConfirmPinState();
}

class _ConfirmPinState extends State<ConfirmPin> {
  bool loading = false;
  bool error = false;
  String otpCode = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // appBar: appBar(context: context, title: "Confirm Pin", canPop: true),
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthAddPinError) AppModal.showErrorAlert(context: context, title: "Reset Pin", desc: state.res.message);
            if (state is AuthAddPinSuccess) {
              await LocalPreferences.savePin(otpCode);
              AppModal.showSuccessAlert(
                dismissOnBackKeyPress: false,
                dismissOnTouchOutside: false,
                context: context,
                title: "Pin Successful created!",
                description: "You will be redirected in 5 seconds",
              );
              Future.delayed(Duration(seconds: 5), () => context.go(AppRoutes.splash));
            }
          },
          builder: (context, state) {
            if (state is AuthAddPinInit) {
              loading = true;
              error = false;
            }
            if (state is AuthAddPinError) {
              loading = false;
              error = true;
            }
            if (state is AuthAddPinSuccess) {
              loading = false;
              error = false;
            }
            return Container(
              height: kHeight(context),
              width: kWidth(context),
              alignment: Alignment.center,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                child: Padding(
                  padding: kAppPadding(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: Image.asset(ImageAssets.logo_and_name, scale: 2)),
                      kh20Spacer(),
                      Text("Confirm Account pin", style: Theme.of(context).textTheme.displayMedium),
                      kh20Spacer(),
                      Text("Please enter the pin you just created to confirm", textAlign: TextAlign.center),
                      kh20Spacer(),
                      AppPin(
                        onChanged: (pin) {
                          setState(() => otpCode = pin);
                        },
                      ),
                      kh20Spacer(),
                      submitButton(
                        loading: loading,
                        context: context,
                        color: otpCode.length > 3 ? Theme.of(context).primaryColor : Theme.of(context).highlightColor,
                        textColor: otpCode.length > 3 ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColorDark,
                        onPressed: otpCode.length > 3 && otpCode == widget.code
                            // ? () => BlocProvider.of<AuthCubit>(context).createPin(
                            //       context,
                            //       ResetPinReqModel(oldPin: "1234", newPin: otpCode),
                            //     )

                            ? () => context.go(AppRoutes.home)
                            : () => showToastError("Pin must be the same"),
                        text: "Confirm",
                      ),
                      kh20Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
