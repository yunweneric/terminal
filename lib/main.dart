import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/config/firebase_options.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/services/service_locator.dart';
import 'package:xoecollect/shared/theme/colors.dart';
import 'package:xoecollect/shared/theme/theme.dart';
import 'package:xoecollect/transactions/logic/transaction/transaction_cubit.dart';
import 'package:xoecollect/users/profile/data/logic/profile/profile_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  // await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

  await dotenv.load(fileName: ".env");

  // * Initialize firebase
  await Firebase.initializeApp(options: await DefaultFirebaseOptions.currentPlatform);
  configLoading();
  await ServiceLocator.setup();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('fr')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(),
      errorWidget: (error) {
        return Placeholder(child: Container(color: primaryColor));
      },
    ),
  );
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.squareCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 50.0
    ..radius = 8.0
    ..maskType = EasyLoadingMaskType.custom
    ..progressColor = kWhite
    ..backgroundColor = Colors.white
    ..indicatorColor = primaryColor
    ..textColor = primaryColor
    ..maskColor = Colors.black.withOpacity(0.3)
    ..userInteractions = false
    ..dismissOnTap = false;
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;
  @override
  void initState() {
    changeTheme();
    window.onPlatformBrightnessChanged = () => changeTheme();
    super.initState();
  }

  changeTheme() {
    final brightness = window.platformBrightness;
    setState(() => isDarkMode = brightness == Brightness.dark);
  }

  ProfileCubit profileCubit = ProfileCubit();
  AuthCubit authCubit = AuthCubit();
  TransactionCubit transactionCubit = TransactionCubit();
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: transactionCubit),
        BlocProvider.value(value: profileCubit),
        BlocProvider.value(value: authCubit),
      ],
      child: LayoutBuilder(builder: (context, constrains) {
        return ScreenUtilInit(
          useInheritedMediaQuery: true,
          builder: (context, child) {
            ThemeData theme = AppTheme.light();
            return MaterialApp.router(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Xoe Collect',
              routerConfig: routes,
              debugShowCheckedModeBanner: false,
              theme: theme,
              useInheritedMediaQuery: false,
              builder: EasyLoading.init(),
            );
          },
        );
      }),
    );
  }
}
