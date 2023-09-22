import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/models/others/routing_models.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? phone;
  bool loading = false;
  bool error = false;
  bool has_accepted_terms = false;
  bool is_password_visible = false;
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
                  // Center(child: Image.asset(ImageAssets.color_logo_and_name, scale: 2)),
                  // kh20Spacer(),
                  Text("Login", style: Theme.of(context).textTheme.displayMedium),
                  kh20Spacer(),
                  Form(
                    child: Column(
                      children: AnimateList(
                        interval: 200.ms,
                        effects: [
                          SlideEffect(end: Offset.zero, begin: Offset(0, 1)),
                          FadeEffect(),
                        ],
                        children: [
                          kh10Spacer(),
                          authInput(
                            width: isMobile(kWidth(context)) ? kWidth(context) : kWidth(context) / 2,
                            context: context,
                            label: "Phone Number",
                            hint: "678276172",
                            keyboardType: TextInputType.phone,
                            prefixIcon: Transform.scale(scale: 0.5, child: SvgPicture.asset(AppIcons.phone)),
                            onChanged: (val) {
                              setState(() {
                                phone = val;
                              });
                            },
                          ),
                          kh20Spacer(),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: has_accepted_terms,
                            contentPadding: kPadding(0, 0),
                            onChanged: loading ? (d) {} : (onChanged) => setState(() => has_accepted_terms = onChanged!),
                            title: GestureDetector(
                              onTap: () => context.push(AppRoutes.terms),
                              child: RichText(
                                text: TextSpan(
                                  text: "By login, you agree with all the",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: " terms and conditions",
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                    TextSpan(
                                      text: " & ",
                                    ),
                                    TextSpan(
                                      text: "privacy policy.",
                                      style: TextStyle(color: Theme.of(context).primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          kh20Spacer(),
                          kh20Spacer(),
                          submitButton(
                            width: isMobile(kWidth(context)) ? kWidth(context) : kWidth(context) / 2,
                            context: context,
                            onPressed: () {
                              if (phone != null) {
                                AppSheet.simpleModal(
                                  context: context,
                                  height: 300.h,
                                  alignment: Alignment.center,
                                  padding: kAppPadding(),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Verification", style: Theme.of(context).textTheme.displayMedium),
                                      kh10Spacer(),
                                      Text(
                                        "We will send a verification code to the number ${phone}. Are you sure you want to proceed?",
                                        textAlign: TextAlign.center,
                                      ),
                                      kh20Spacer(),
                                      submitButton(
                                        context: context,
                                        onPressed: () {
                                          context.pop();
                                          context.push(
                                            AppRoutes.verify_screen,
                                            extra: VerificationRoutingModel(
                                              AppBaseResponse(data: {}, statusCode: 200, message: ""),
                                              phone!,
                                            ),
                                          );
                                        },
                                        text: "Yes Proceed",
                                      ),
                                      kh10Spacer(),
                                      submitButton(
                                        color: Theme.of(context).cardColor,
                                        textColor: Theme.of(context).primaryColor,
                                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                        context: context,
                                        onPressed: () => context.pop(),
                                        text: "No, change it!",
                                      ),
                                    ],
                                  ),
                                );
                              } else
                                showToastError("Please enter a valid phone number");
                            },
                            text: "Login",
                          ),
                          kh20Spacer(),
                        ],
                      ),
                    ),
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
