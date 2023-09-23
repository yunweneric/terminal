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
import 'package:xoecollect/shared/components/modals.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Text("Enter your account pin", style: Theme.of(context).textTheme.displayMedium),
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
                  onPressed: otpCode.length > 3
                      ? () => BlocProvider.of<AuthCubit>(context).createPin(
                            context,
                            otpCode,
                          )
                      : () => showToastError("Pin must be the same"),
                  text: "Confirm",
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
