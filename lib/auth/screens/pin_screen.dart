import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/widgets/app_pin.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/loaders.dart';
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(child: Image.asset(ImageAssets.logo_and_name, scale: 2)),
                kh20Spacer(),
                Text("Set your PIN code ", style: Theme.of(context).textTheme.displayLarge),
                kh20Spacer(),
                Text(
                  "Add a PIN to make your account more secure. You may be asked for a PIN when making a transaction.",
                  // textAlign: TextAlign.center,
                ),
                kh20Spacer(),
                kh20Spacer(),
                AppPin(
                  length: 4,
                  onChanged: (pin) {
                    setState(() => otpCode = pin);
                  },
                ),
                kh20Spacer(),
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
                  text: "Add Pin",
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
            if (state is AuthAddPinInit) {
              AppLoaders.showLoader(context: context);
            }
            if (state is AuthAddPinError) {
              AppLoaders.dismissEasyLoader();
              AppSheet.appErrorSheet(
                context: context,
                message: state.res.message,
                okAction: () {},
                onCancel: () {},
              );
            }

            if (state is AuthAddPinSuccess) {
              AppLoaders.dismissEasyLoader();
              await LocalPreferences.savePin(state.pin);
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      kh20Spacer(),
                      Text("Confirm PIN code 🔐 ", style: Theme.of(context).textTheme.displayLarge),
                      kh20Spacer(),
                      Text(
                        "Confirm the PIN to make your account more secure. You may be asked for a PIN when making a transaction.",
                      ),
                      kh20Spacer(),
                      kh20Spacer(),
                      AppPin(
                        length: 4,
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
                            ? () => BlocProvider.of<AuthCubit>(context).createPin(
                                  context,
                                  otpCode,
                                )
                            : () => showToastError("Pin must be the same"),
                        text: "Confirm Pin",
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
