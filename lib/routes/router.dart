import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/screens/login_screen.dart';
import 'package:xoecollect/auth/screens/pin_screen.dart';
import 'package:xoecollect/auth/screens/verify_screen.dart';
import 'package:xoecollect/shared/models/others/routing_models.dart';
import 'package:xoecollect/home/home_screen.dart';
import 'package:xoecollect/start/splash_screen.dart';
import 'package:xoecollect/start/start_screen.dart';

import 'index.dart';

CustomTransitionPage transitionEffect({required state, required Widget child}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
  );
}

//*----------------------------------------------------------------
//* GoRouter configuration
//*----------------------------------------------------------------

final routes = GoRouter(
  routes: [
    // ** Splash screen routes
    GoRoute(path: AppRoutes.splash, pageBuilder: (context, state) => transitionEffect(state: state, child: SplashScreen())),

    // ** Onboarding routes
    GoRoute(path: AppRoutes.start, pageBuilder: (context, state) => transitionEffect(state: state, child: StartScreen())),

    // ** Home routes
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => transitionEffect(state: state, child: HomeScreen()),
    ),

    // ** Authentication routes
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => transitionEffect(state: state, child: LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.add_pin_screen,
      pageBuilder: (context, state) => transitionEffect(state: state, child: AddPinScreen(fromSplashScreen: false)),
    ),
    GoRoute(
      path: AppRoutes.verify_screen,
      pageBuilder: (context, state) => transitionEffect(
        state: state,
        child: VerifyScreen(verify_data: state.extra as VerificationRoutingModel),
      ),
    ),
  ],
);
