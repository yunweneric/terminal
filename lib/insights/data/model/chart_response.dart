import 'package:xoecollect/insights/data/model/chart_group_model.dart';

class GetChartDataResponse {
  final List<ChartGroupData> data;
  final double max_value;
  final double range;

  GetChartDataResponse({required this.data, required this.max_value, required this.range});
}
