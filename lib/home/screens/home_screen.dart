import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xoecollect/home/screens/widgets/home_header.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/states_widgets.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/screens/widgets/trannsaction_card.dart';

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
    List<AppTransaction> transactions = List.generate(
      20,
      (index) => AppTransaction.fake(),
    );
    return Scaffold(
      body: Container(
        height: kHeight(context),
        child: Column(
          children: [
            HeaderSection(),
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
                            return transactionCard(context, transaction);
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
}
