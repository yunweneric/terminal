import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/data/model/pinn_routing_model.dart';
import 'package:xoecollect/auth/screens/login_screen.dart';
import 'package:xoecollect/auth/screens/pin_auth.dart';
import 'package:xoecollect/auth/screens/pin_screen.dart';
import 'package:xoecollect/auth/screens/verify_screen.dart';
import 'package:xoecollect/shared/models/others/routing_models.dart';
import 'package:xoecollect/home/screens/home_screen.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/screens/layout/base_layout.dart';
import 'package:xoecollect/start/splash_screen.dart';
import 'package:xoecollect/start/start_screen.dart';
import 'package:xoecollect/transactions/deposits/screen/deposit_screen.dart';
import 'package:xoecollect/transactions/screens/transaction_details.dart';
import 'package:xoecollect/transactions/screens/transaction_home.dart';
import 'package:xoecollect/users/profile/screens/profile_screen.dart';
import 'package:xoecollect/vault/screen/vault_screen.dart';

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
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) => transitionEffect(state: state, child: SplashScreen()),
    ),

    // ** Onboarding routes
    GoRoute(
      path: AppRoutes.start,
      pageBuilder: (context, state) => transitionEffect(state: state, child: StartScreen()),
    ),

    // ** Home routes
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) => transitionEffect(state: state, child: HomeScreen()),
    ),

    // ** Home routes
    GoRoute(
      path: AppRoutes.base,
      pageBuilder: (context, state) => transitionEffect(state: state, child: BaseHomeScreen()),
    ),

    GoRoute(
      path: AppRoutes.transactions,
      pageBuilder: (context, state) => transitionEffect(state: state, child: TransactionHomeScreen()),
    ),
    GoRoute(
      path: AppRoutes.transaction_details,
      pageBuilder: (context, state) => transitionEffect(
        state: state,
        child: TransactionDetails(transaction: state.extra as AppTransaction),
      ),
    ),

    GoRoute(
      path: AppRoutes.deposit,
      pageBuilder: (context, state) => transitionEffect(state: state, child: DepositScreen()),
    ),

    GoRoute(
      path: AppRoutes.vault,
      pageBuilder: (context, state) => transitionEffect(state: state, child: VaultScreen()),
    ),

    GoRoute(
      path: AppRoutes.profile,
      pageBuilder: (context, state) => transitionEffect(state: state, child: ProfileScreen()),
    ),

    // ** Authentication routes
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => transitionEffect(
        state: state,
        child: LoginScreen(),
      ),
    ),

    GoRoute(
      path: AppRoutes.add_pin_screen,
      pageBuilder: (context, state) => transitionEffect(state: state, child: AddPinScreen(fromSplashScreen: false)),
    ),
    GoRoute(
      path: AppRoutes.auth_pin_screen,
      pageBuilder: (context, state) => transitionEffect(
        state: state,
        child: PinAuthScreen(pinActions: state.extra as PinRoutingModel),
      ),
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
