import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
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
                              }),
                          kh20Spacer(),
                          submitButton(
                            width: isMobile(kWidth(context)) ? kWidth(context) : kWidth(context) / 2,
                            context: context,
                            onPressed: () {
                              if (phone != null) {
                                context.push(
                                  AppRoutes.verify_screen,
                                  extra: VerificationRoutingModel(
                                    AppBaseResponse(data: {}, statusCode: 200, message: ""),
                                    phone!,
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
