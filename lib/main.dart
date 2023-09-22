import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/theme/colors.dart';
import 'package:xoecollect/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      logI(constrains);
      return ScreenUtilInit(
        useInheritedMediaQuery: true,
        // designSize: isMobile(constrains.maxWidth) ? Size(360, 690) : Size(1920, 1080),
        // designSize: Size(1920, 1080),
        // scaleByHeight: true,
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
          );
        },
      );
    });
  }
}
