import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/home/home_card.dart';
import 'package:xoecollect/home/home_header.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/states_widgets.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
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
    Faker faker = Faker();

    List<AppTransaction> transactions = List.generate(
      20,
      (index) => AppTransaction(
        amount: faker.randomGenerator.integer(100000, min: 2000),
        createdAt: DateTime.now(),
        name: faker.person.firstName(),
        id: faker.jwt.secret,
      ),
    );
    return Scaffold(
      body: Container(
        height: kHeight(context),
        child: Column(
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
                        khSpacer(kToolbarHeight + 20.h),
                        Expanded(
                          child: Text(
                            "Cash Collect",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(color: kWhite),
                          ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "22,000",
                                    style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kWhite, fontSize: 45.sp),
                                  ),
                                  Text(
                                    "Available Balance",
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: kWhite, fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                              Positioned(
                                top: 0,
                                right: -30,
                                child: Text(
                                  "FCFA",
                                  style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kWhite),
                                ),
                              ),
                            ],
                          ),
                          kwSpacer(30.w),
                          Transform.scale(scale: 1, child: SvgPicture.asset(AppIcons.visibility_off))
                        ],
                      ),
                    ],
                  ),
                  kh20Spacer(),
                  kh20Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      headerChip(context: context, title: "Withdraw", onTap: () {}),
                      kwSpacer(10.w),
                      headerChip(context: context, title: "Deposit", onTap: () {}, isDeposit: true),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: kWidth(context),
                      padding: kph(20.w),
                      child: appLoaderBuilder(
                        // loading: loadKyc || loadingUser,
                        // error: errorUser || errorKyc,
                        loading: false,
                        error: false,
                        hasData: true,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: transactions.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (c, i) {
                            final transaction = transactions[i];
                            return transactionCard(transaction);
                          },
                          separatorBuilder: (c, i) => Container(margin: kpv(5.h), child: Divider(indent: 60.w)),
                        ),
                        // child: Column(children: []),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              kh20Spacer(),
                              kh20Spacer(),
                              SvgPicture.asset(SvgAsset.no_transaction),
                              kh20Spacer(),
                              Text("No AppTransactions", style: Theme.of(context).textTheme.displayMedium),
                              kh10Spacer(),
                              Text("You haven't made any transactions."),
                            ],
                          ),
                        ),
                      ),
                    ),
                    khSpacer(30.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container transactionCard(AppTransaction transaction) {
    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 25.r,
            child: Text(
              Formaters.formatDateBase(transaction.createdAt, "H:m"),
            ),
          ),
          kwSpacer(10.w),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(transaction.name),
                    Text(transaction.id, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                Text(transaction.amount.toString() + "F"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget headerChip({required BuildContext context, bool? isDeposit, required String title, required VoidCallback onTap}) {
    return submitButton(
      padding: kPadding(0, 15.h),
      icon: CircleAvatar(
        backgroundColor: kWhite,
        radius: 12.r,
        child: Icon(Icons.add),
      ),
      width: 150.w,
      context: context,
      onPressed: () {},
      color: isDeposit == true ? Theme.of(context).hintColor : kDangerLight,
      text: title,
      textColor: kDark,
    );
  }
}
