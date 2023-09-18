import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ez_trip/routes/index.dart';
import 'package:ez_trip/shared/components/buttons.dart';
import 'package:ez_trip/shared/components/radius.dart';
import 'package:ez_trip/shared/utils/index.dart';
import 'package:ez_trip/shared/utils/sizing.dart';
import 'package:ez_trip/theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool has_accepted_terms = false;
  bool is_password_visible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: kheight(context),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: kAppPading(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image.asset(ImageAssets.color_logo_and_name, scale: 2)),
                  kh20Spacer(),
                  Text("Login", style: Theme.of(context).textTheme.displayLarge),
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
                            label: "Username",
                            hint: "Ex: blackcat237",
                            prefixIcon: Transform.scale(scale: 0.5, child: SvgPicture.asset(AppIcons.user)),
                          ),
                          authInput(
                            label: "Password",
                            hint: "At least 8 characters",
                            prefixIcon: Transform.scale(scale: 0.5, child: SvgPicture.asset(AppIcons.lock)),
                            obscureText: !is_password_visible,
                            sufficIcon: InkWell(
                              onTap: () {
                                setState(() => is_password_visible = !is_password_visible);
                              },
                              child: Transform.scale(scale: 0.5, child: SvgPicture.asset(!is_password_visible ? AppIcons.visibility_on : AppIcons.visibility_off)),
                            ),
                          ),
                          kh20Spacer(),
                          CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            value: has_accepted_terms,
                            contentPadding: kpadding(0, 0),
                            onChanged: (onChanged) => setState(
                              () => has_accepted_terms = onChanged!,
                            ),
                            title: RichText(
                              text: TextSpan(
                                text: "By login, you agree with all the",
                                style: Theme.of(context).textTheme.bodyMedium,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: " terms and conditions",
                                    style: TextStyle(color: kSuccess),
                                  ),
                                  TextSpan(
                                    text: " & ",
                                  ),
                                  TextSpan(
                                    text: "privacy policy.",
                                    style: TextStyle(color: kSuccess),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          kh20Spacer(),
                          submitButton(context: context, onPressed: () {}, text: "Login"),
                          kh20Spacer(),
                          Container(
                            decoration: BoxDecoration(color: Theme.of(context).highlightColor.withOpacity(0.2), borderRadius: radiusM()),
                            padding: kpadding(20.w, 20.h),
                            child: Row(
                              children: [
                                Container(
                                  height: 40.h,
                                  width: 40.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).hoverColor.withOpacity(0.2),
                                    borderRadius: radiusSm(),
                                  ),
                                  child: Transform.scale(scale: 0.5, child: SvgPicture.asset(AppIcons.login)),
                                ),
                                kwSpacer(10.w),
                                GestureDetector(
                                  onTap: () => context.push(AppRoutes.register),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't yet have an account?",
                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "\nRegister",
                                          style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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

  Widget authInput({
    required String label,
    required String hint,
    Widget? prefixIcon,
    Widget? sufficIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      margin: kpadding(0, 10.h),
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
