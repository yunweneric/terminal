import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xoecollect/home/home_screen.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class BaseHomeScreen extends StatefulWidget {
  const BaseHomeScreen({super.key});

  @override
  State<BaseHomeScreen> createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen> {
  int currentIndex = 0;

  List<BottomNavigationBarItem> nav_items(context) => [
        NavItem(context: context, icon: AppIcons.home, title: "Home"),
        NavItem(context: context, icon: AppIcons.contact, title: "Contact"),
        NavItem(context: context, icon: AppIcons.insight, title: "Insights"),
        NavItem(context: context, icon: AppIcons.account, title: "Account"),
      ];
  BottomNavigationBarItem NavItem({required BuildContext context, required String icon, required String title}) {
    return BottomNavigationBarItem(
      label: title,
      icon: SvgPicture.asset(icon, color: Theme.of(context).primaryColorDark),
      activeIcon: SvgPicture.asset("${icon}_filled", color: Theme.of(context).primaryColor),
    );
  }

  List<Widget> pages = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: nav_items(context),
        onTap: (item) => setState(() {
          currentIndex = item;
        }),
      ),
      body: pages[currentIndex],
    );
  }
}
