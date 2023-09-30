import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:xoecollect/insights/screens/widget/areat_chart.dart';
import 'package:xoecollect/insights/screens/widget/transaction_chart.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/shared/theme/colors.dart';

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class InsightScreen extends StatefulWidget {
  const InsightScreen({super.key});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  late List<_ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [_ChartData('20', 12), _ChartData('30', 15), _ChartData('22', 30), _ChartData('32', 6.4), _ChartData('8', 14)];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context: context,
        title: "Insight",
        centerTitle: true,
        style: Theme.of(context).textTheme.displayMedium,
        bgColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              kh20Spacer(),
              Container(
                margin: kPadding(20.w, 0),
                padding: kPadding(0.w, 10.h),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).highlightColor),
                  borderRadius: radiusSm(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: kPadding(20.w, 10.h),
                      child: Row(
                        children: [
                          Text("Show chart in", style: Theme.of(context).textTheme.displayMedium),
                        ],
                      ),
                    ),
                    Divider(endIndent: 10.w, indent: 10.w),
                    TransactionChart(),
                  ],
                ),
              ),
              kh20Spacer(),
              Padding(
                padding: kAppPadding(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AreaChart(colors: [kDanger, kDanger], amount: 40000, title: "Withdrawals", percentage: 40),
                    AreaChart(colors: [Theme.of(context).hoverColor, Theme.of(context).hoverColor], amount: 2000, title: "Deposits", percentage: 40),
                  ],
                ),
              ),
              kh20Spacer(),
              Container(
                margin: kPadding(20.w, 0),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).highlightColor),
                  borderRadius: radiusSm(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: kPadding(10.w, 8.h),
                      child: Text("Number of Transactions", style: Theme.of(context).textTheme.displayMedium),
                    ),
                    Divider(),
                    Container(
                      padding: kPadding(0.w, 15.h),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              dashNumber(context: context, number: "12", title: "Income"),
                              dashNumber(context: context, number: "43", title: "Sent", isMiddle: true),
                              dashNumber(context: context, number: "56", title: "Request"),
                            ],
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              dashNumber(context: context, number: "09", title: "Top Up"),
                              dashNumber(context: context, number: "38", title: "Withdraw", isMiddle: true),
                              dashNumber(context: context, number: "46", title: "Total Transaction"),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              khSpacer(30.h),
            ],
          ),
        ),
      ),
    );
  }
}

Widget dashNumber({required BuildContext context, required String number, required String title, bool? isMiddle}) {
  return Container(
    width: kWidth(context) / 4,
    // padding: kPadding(30.w, 20.h),
    decoration: BoxDecoration(
      border: isMiddle == null ? null : Border.symmetric(vertical: BorderSide(color: Theme.of(context).highlightColor, width: 1.w)),
    ),
    child: Column(
      children: [
        Text(number, style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center),
        Text(title, textAlign: TextAlign.center),
      ],
    ),
  );
}
