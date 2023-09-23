import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xoecollect/home/home_screen.dart';
import 'package:xoecollect/shared/utils/index.dart';

class BaseHomeScreen extends StatefulWidget {
  const BaseHomeScreen({super.key});

  @override
  State<BaseHomeScreen> createState() => _BaseHomeScreenState();
}

class _BaseHomeScreenState extends State<BaseHomeScreen> {
  int currentIndex = 0;

  List<BottomNavigationBarItem> nav_items(context) => [
        NavItem(context: context, icon: AppIcons.home, title: "Home", filled_icon: AppIcons.home_filled),
        NavItem(context: context, icon: AppIcons.contact, title: "Contact", filled_icon: AppIcons.contact_filled),
        NavItem(context: context, icon: AppIcons.insight, title: "Insights", filled_icon: AppIcons.insight_filled),
        NavItem(context: context, icon: AppIcons.account, title: "Account", filled_icon: AppIcons.account_filled),
      ];
  BottomNavigationBarItem NavItem({
    required BuildContext context,
    required String icon,
    required String filled_icon,
    required String title,
  }) {
    return BottomNavigationBarItem(
      label: title,
      icon: SvgPicture.asset(icon, color: Theme.of(context).primaryColorDark),
      activeIcon: SvgPicture.asset(filled_icon),
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
        // fixedColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedLabelStyle: TextStyle(fontSize: 12.sp),
        selectedLabelStyle: TextStyle(fontSize: 12.sp),
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
