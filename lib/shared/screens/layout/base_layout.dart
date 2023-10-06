import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/auth/data/model/pinn_routing_model.dart';
import 'package:xoecollect/contacts/contact_screen.dart';
import 'package:xoecollect/contacts/logic/contact/contact_cubit.dart';
import 'package:xoecollect/home/screens/home_screen.dart';
import 'package:xoecollect/insights/screens/insights.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/services/app_state_service.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/users/profile/screens/profile_screen.dart';

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
    BlocProvider(
      create: (context) => ContactCubit(),
      child: ContactScreen(),
    ),
    InsightScreen(),
    ProfileScreen(),
  ];

  listenToAppState() {
    WidgetsBinding.instance.addObserver(
      LifecycleEventHandler(
        resumeCallBack: () {
          // context.read<AuthCubit>().lockApp(context);
          logI("Resumed");
          context.push(
            AppRoutes.auth_pin_screen,
            extra: PinRoutingModel(
              onVerified: (_) {
                context.pop();
              },
            ),
          );
          return Future.value();
        },
        suspendingCallBack: () async {},
      ),
    );
  }

  @override
  void initState() {
    listenToAppState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).primaryColorLight,
      ),
    );
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
