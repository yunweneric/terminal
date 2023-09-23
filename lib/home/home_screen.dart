import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/home/home_card.dart';
import 'package:xoecollect/home/home_header.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/components/avatar_circle.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/states_widgets.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadKyc = true;
  bool loadingUser = true;
  bool loadedBoth = false;
  bool loadingFeeds = false;
  bool errorUser = false;
  bool errorFeeds = false;
  bool errorKyc = false;
  double percentage = 0;
  AppUser? user;

  @override
  void initState() {
    user = AppUser.fake();
    // AppLoaders.dismissEasyLoader();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderSection(
            user: user,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.h),
                  padding: kPadding(30.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text("Cash Collect"),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: user == null ? () {} : () => context.push(AppRoutes.profile, extra: user),
                            child: SvgPicture.asset(AppIcons.bell),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      " Total Transactions",
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: kWhite),
                    ),
                    Text(
                      "22,000FCFA",
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kWhite),
                    ),
                  ],
                ),
              ],
            ),
          ),
          khSpacer(50.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            width: kWidth(context),
            padding: kph(20.w),
            child: appLoaderBuilder(
              // loading: loadKyc || loadingUser,
              // error: errorUser || errorKyc,
              loading: false,
              error: false,
              hasData: user != null,
              child: AppHome(user: user),
              loadingShimmer: AppStateWidget.loadingWidget(context: context, height: kHeight(context) / 1.5),
              errorWidget: Container(
                width: kWidth(context),
                alignment: Alignment.center,
                height: 200.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor,
                  borderRadius: radiusSm(),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Could not load data"),
                    submitButton(
                      width: 90.w,
                      padding: kPadding(0.w, 6.h),
                      borderRadius: radiusVal(10.r),
                      context: context,
                      onPressed: () => {},
                      icon: Icon(Icons.refresh),
                      text: "Reload",
                      fontSize: 11.sp,
                    ),
                  ],
                ),
              ),
              noDataWidget: Container(
                child: Text("No data"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
