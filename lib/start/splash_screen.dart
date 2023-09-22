import 'dart:async';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/utils/image_assets.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    reRouteUser();
    super.initState();
  }

  reRouteUser() async {
    bool hasInit = await LocalPreferences.getInit();
    if (!hasInit) {
      Future.delayed(1200.ms, () {
        context.go(AppRoutes.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: kHeight(context),
            width: kWidth(context),
            child: new BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: new Container(
                decoration: new BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
            decoration: BoxDecoration(
              color: kDark,
              image: DecorationImage(
                image: AssetImage(ImageAssets.splash_image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            child: Container(
              color: kDark.withOpacity(0.5),
              // color: Theme.of(context).primaryColor.withOpacity(0.8),
              child: Bounce(
                child: Center(
                  child: Text(
                    "Xoe Collect",
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kWhite, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
