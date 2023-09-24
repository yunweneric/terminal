// import 'package:fl_chart_app/presentation/resources/app_resources.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class AreaChart extends StatefulWidget {
  final List<Color> colors;
  final String title;
  final int amount;
  final int percentage;
  const AreaChart({super.key, required this.colors, required this.title, required this.amount, required this.percentage});

  @override
  State<AreaChart> createState() => _AreaChartState();
}

class _AreaChartState extends State<AreaChart> {
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120.h,
          width: kWidth(context) / 2.3,
          child: ClipRRect(
            borderRadius: radiusM(),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false, drawHorizontalLine: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: true, border: Border.all(color: Theme.of(context).highlightColor)),
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: 12,
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(2.6, 2),
                      FlSpot(4.9, 5),
                      FlSpot(6.8, 3.1),
                      FlSpot(8, 4),
                      FlSpot(9.5, 3),
                      FlSpot(11, 4),
                    ],
                    isCurved: true,
                    gradient: LinearGradient(colors: [widget.colors.first, widget.colors.first]),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: widget.colors.map((color) => color.withOpacity(0.4)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 20.h,
          left: 20.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${widget.title}"),
                  kwSpacer(10.w),
                  Text(
                    widget.title == "Expense" ? "-${widget.percentage}%" : "+${widget.percentage}%",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(color: widget.colors.first, letterSpacing: 1.2.w),
                  ),
                ],
              ),
              khSpacer(2.h),
              Text("${Formaters.formatCurrency(widget.amount)} Fcfa", style: Theme.of(context).textTheme.displayMedium),
            ],
          ),
        )
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
}
