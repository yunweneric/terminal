import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:terminal/routes/index.dart';
import 'package:terminal/theme/colors.dart';
import 'package:terminal/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
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
    return ScreenUtilInit(
      designSize: Size(360, 690),
      builder: (context, child) {
        ThemeData theme = isDarkMode ? ZappyMealAppTheme.dark() : ZappyMealAppTheme.light();
        return MaterialApp.router(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          title: 'Zappy Meals',
          routerConfig: routes,
          debugShowCheckedModeBanner: false,
          theme: theme,
          useInheritedMediaQuery: true,
        );
      },
    );
  }
}
