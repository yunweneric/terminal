import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:ez_trip/routes/index.dart';
import 'package:ez_trip/shared/utils/image_assets.dart';
import 'package:ez_trip/shared/utils/local_storage.dart';
import 'package:ez_trip/shared/utils/sizing.dart';

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
    bool hasInit = await LocalPrefs.getInit();
    if (!hasInit) {
      Future.delayed(1200.ms, () {
        context.go(AppRoutes.start);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: kheight(context),
        width: kwidth(context),
        child: Bounce(child: Image.asset(ImageAssets.logo_and_name, scale: 2)),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(1),
          image: DecorationImage(
            image: AssetImage(ImageAssets.splash_image),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
