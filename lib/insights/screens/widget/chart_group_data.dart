import 'package:fl_chart/fl_chart.dart';
import 'package:xoecollect/shared/theme/colors.dart';

BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: [
      BarChartRodData(
        toY: y1,
        color: kSecondaryColor,
        width: 7,
      ),
      BarChartRodData(
        toY: y2,
        color: kDanger,
        width: 7,
      ),
    ],
  );
}
