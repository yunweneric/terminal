import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_plus_keyboard/package/controllers/pin_input_controller.dart';
import 'package:pin_plus_keyboard/package/pin_plus_keyboard_package.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/screens/widget/pin_code_fields.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/modals.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:custom_pin_screen/custom_pin_screen.dart';

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
        child: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthVerifyPinError) {
              AppLoaders.showLoader(context: context);
            }
            if (state is AuthVerifyPinError) {
              AppModal.showErrorAlert(context: context, title: "Pin verification", desc: state.res.message);
              AppLoaders.dismissEasyLoader();
            }
            if (state is AuthAddPinSuccess) {
              AppLoaders.dismissEasyLoader();
              context.pop();
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: kHeight(context),
            width: kWidth(context),
            padding: kAppPadding(),
            child: SizedBox(
              height: kHeight(context) / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 4; i++)
                        PinCodeField(
                          key: Key('pinField$i'),
                          pin: otpCode,
                          pinCodeFieldIndex: i,
                          theme: PinTheme(keysColor: Theme.of(context).highlightColor),
                        ),
                    ],
                  ),
                  kh10Spacer(),
                  CustomKeyBoard(
                    pinTheme: PinTheme.defaults(),
                    onChanged: (v) {
                      setState(() {
                        otpCode = v;
                      });
                    },
                    // specialKey: Icon(
                    //   Icons.fingerprint,
                    //   key: const Key('fingerprint'),
                    //   color: Theme.of(context).primaryColor,
                    //   size: 50,
                    // ),
                    onCompleted: (p) {
                      context.pop();
                      BlocProvider.of<AuthCubit>(context).verifyPin(context, p);
                    },
                    specialKeyOnTap: () {},
                    maxLength: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
