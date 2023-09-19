import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/models/account/user_model.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/screens/home/home_card.dart';
import 'package:xoecollect/screens/home/home_header.dart';
import 'package:xoecollect/shared/components/avatar_circle.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/states_widgets.dart';
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
    Faker faker = Faker();
    user = AppUser(
      uuid: Uuid().v1(),
      createdAt: DateTime.now(),
      email: faker.internet.email(),
      username: faker.person.firstName(),
      phone: faker.phoneNumber.us(),
      role: Role(
        createdAt: DateTime.now(),
        uuid: '',
        name: '',
        description: '',
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
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
                      RichText(
                        text: TextSpan(
                          text: user?.username == null ? 'Hi --\n' : "Hi ${user?.username}\n",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 22.sp, color: kWhite),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Welcome",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp, color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          // SvgPicture.asset(AppIcons.bell),
                          // kwSpacer(5.w),
                          InkWell(
                            onTap: user == null ? () {} : () => context.push(AppRoutes.profile, extra: user),
                            // onTap: () => context.push(AppRoutes.rate_driver_trip + "/spp"),
                            child: avatarCircle(image: user?.username, context: context, radius: 18.r),
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
          Positioned(
            top: 270.h,
            left: 10,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(15.r), topRight: Radius.circular(15.r)),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              width: kWidth(context),
              padding: kph(10.w),
              child: appLoaderBuilder(
                // loading: loadKyc || loadingUser,
                // error: errorUser || errorKyc,
                loading: false,
                error: false,
                hasData: user != null,
                child: Column(
                  children: [
                    khSpacer(50.h),
                    AppHome(user: user),
                  ],
                ),
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
          )
        ],
      ),
    );
  }
}
