import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/clippers.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: kHeight(context),
        width: kWidth(context),
      ),
    );
  }

  Widget page({required BuildContext context}) {
    return Stack(
      children: [
        Builder(builder: (context) {
          return Container(
            width: kWidth(context),
            height: kHeight(context) * 0.7,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.base_splash + "${current_index}.png"),
                fit: BoxFit.cover,
              ),
            ),
            // child: Image.asset(ImageAssets.splash_image3, fit: BoxFit.cover),
          );
        }).animate().fadeIn(),
        Positioned(
          bottom: 0,
          child: ClipPath(
            clipper: AppCustomClipper(),
            child: Container(
              height: kHeight(context) * 0.5,
              width: kWidth(context),
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  khSpacer(30.h),
                  Container(
                    height: 150.h,
                    // color: Colors.teal,
                    child: PageView(
                      onPageChanged: (page) {
                        setState(() {
                          current_index = page;
                        });
                      },
                      children: [
                        textWidget(
                          context: context,
                          first_text: "The Fastest In Delivering",
                          second_text: "Food",
                          description: "Lorem ipsum dolor sit amet consectetur. Nibh ultricies nunc",
                        ),
                        textWidget(
                          context: context,
                          first_text: "You will become very",
                          second_text: "Addicted",
                          description: "Lorem ipsum dolor sit amet consectetur. Nibh ultricies nunc",
                        ),
                        textWidget(
                          context: context,
                          first_text: "Let’s Start enjoying",
                          second_text: "with Us",
                          description: "Lorem ipsum dolor sit amet consectetur. Nibh ultricies nunc",
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) {
                        return current_index == index
                            ? Container(
                                width: 40.w,
                                height: 5.h,
                                decoration: BoxDecoration(color: Theme.of(context).hoverColor, borderRadius: radiusM()),
                              ).animate().slideX()
                            : Container(margin: kph(10.w), child: CircleAvatar(backgroundColor: Theme.of(context).hoverColor, radius: 3.r));
                      },
                    ),
                  ),
                  kh20Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SlideInUp(
                        delay: 200.ms,
                        child: submitButton(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderSide: BorderSide(width: 1.w, color: Theme.of(context).primaryColor),
                          width: 90.w,
                          textColor: Theme.of(context).primaryColor,
                          context: context,
                          onPressed: () {
                            context.go(AppRoutes.login);
                          },
                          padding: kPadding(10.w, 15.h),
                          text: "Login",
                        ),
                      ),
                      kwSpacer(20.w),
                      SlideInUp(
                        delay: 400.ms,
                        child: submitButton(
                          padding: kPadding(10.w, 12.h),
                          width: 180.w,
                          context: context,
                          onPressed: () {},
                          text: "Get started",
                          isReversed: true,
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textWidget({required BuildContext context, required String first_text, required String second_text, required String description}) {
    return FadeIn(
      child: Container(
        padding: kPadding(50.w, 0),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: first_text,
                style: Theme.of(context).textTheme.displayLarge,
                children: <TextSpan>[
                  TextSpan(
                    text: " ${second_text}",
                    style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                ],
              ),
            ),
            kh20Spacer(),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
