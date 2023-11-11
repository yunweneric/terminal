import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/insights/logic/cubit/chart_cubit.dart';
import 'package:xoecollect/insights/screens/widget/chart_group_data.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/shared/theme/colors.dart';

class TransactionChart extends StatefulWidget {
  TransactionChart({super.key});
  final Color leftBarColor = kSecondaryColor;
  final Color rightBarColor = kDanger;
  final Color avgColor = primaryColor;
  @override
  State<StatefulWidget> createState() => TransactionChartState();
}

class TransactionChartState extends State<TransactionChart> {
  List<BarChartGroupData> rawBarGroups = [];
  List<BarChartGroupData> showingBarGroups = [];

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();

    setBarData();
    context.read<ChartCubit>().getCharData(context);
  }

  void setBarData() async {
    // final items = [
    //   makeGroupData(0, 5, 12),
    //   makeGroupData(1, 16, 2),
    //   makeGroupData(2, 18, 5),
    //   makeGroupData(3, 8, 16),
    //   makeGroupData(4, 17, 6),
    //   makeGroupData(5, 22, 10),
    //   makeGroupData(5, 19, 1.5),
    // ];

    showingBarGroups = rawBarGroups;
  }

  double maxValue = 30.0;
  double range = 10.0;
  // double
  @override
  Widget build(BuildContext context) {
    setBarData();
    return BlocConsumer<ChartCubit, ChartState>(
      listener: (context, state) {},
      builder: (context, state) {
        logI(state);
        if (state is ChartFetchSuccess) {
          // rawBarGroups = state.data.data.map((e) => makeGroupData(e.x, e.y1, e.y2)).toList();
          showingBarGroups = state.data.data.map((e) => makeGroupData(e.x, e.y1, e.y2)).toList();
          maxValue = state.data.max_value;
          range = state.data.range;
          logI({"max": state.data.max_value, "range": range});
          List res = state.data.data.map((element) {
            return element.toJson();
          }).toList();
          print(res);
        }
        return AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: kPadding(10.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: AnimatedSwitcher(
                    key: ValueKey(showingBarGroups),
                    duration: Duration(seconds: 3),
                    child: showingBarGroups.length == 0 ? AppLoaders.loadingWidget(context) : chartWidget(showingBarGroups),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget chartWidget(showingBarGroup) {
    return ZoomIn(
      child: BarChart(
        BarChartData(
          // * todo set max value
          maxY: maxValue,
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
                reservedSize: 42,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                interval: range,
                getTitlesWidget: leftTitles,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: showingBarGroup,
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    // logI(value);
    TextStyle style = TextStyle(color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 7.sp);
    String text = Formaters.formatCurrencyInKValues(value.toInt());
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  // BarChartGroupData makeGroupData(int x, double y1, double y2) {
  //   return BarChartGroupData(
  //     barsSpace: 4,
  //     x: x,
  //     barRods: [
  //       BarChartRodData(
  //         toY: y1,
  //         color: widget.leftBarColor,
  //         width: width,
  //       ),
  //       BarChartRodData(
  //         toY: y2,
  //         color: widget.rightBarColor,
  //         width: width,
  //       ),
  //     ],
  //   );
  // }
}
