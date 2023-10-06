import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/insights/logic/cubit/chart_cubit.dart';
import 'package:xoecollect/insights/screens/widget/chart_group_data.dart';
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

    context.read<ChartCubit>().getCharData(context);
  }

  void setBarData() {
    final items = [
      makeGroupData(0, 5, 12),
      makeGroupData(1, 16, 2),
      makeGroupData(2, 18, 5),
      makeGroupData(3, 80, 16),
      makeGroupData(4, 17, 6),
      makeGroupData(5, 19, 1.5),
      makeGroupData(6, 22, 10),
    ];

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  double maxValue = 30.0;
  double range = 10.0;
  // double
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChartCubit, ChartState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChartFetchSuccess) {
          // logI(state.data.max_value);
          // rawBarGroups = state.data.data.map((e) => makeGroupData(e.x, e.y1, e.y2)).toList();
          // showingBarGroups = state.data.data.map((e) => makeGroupData(e.x, e.y1, e.y2)).toList();
          // maxValue = state.data.max_value;
          // range = state.data.range;
          // state.data.data.forEach((element) {
          //   logI(element.toJson());
          // });
        }
        return AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: kPadding(10.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: BarChart(
                    BarChartData(
                      // * todo set max value
                      maxY: 268517.0,
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
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    // logI(value);
    TextStyle style = TextStyle(color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14.sp);
    String text = Formaters.formatCurrency(value.toInt());
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
