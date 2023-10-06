part of 'chart_cubit.dart';

@immutable
class ChartState {}

class ChartInitial extends ChartState {}

class ChartFetchInitial extends ChartState {}

class ChartFetchError extends ChartState {}

class ChartFetchSuccess extends ChartState {
  final GetChartDataResponse data;

  ChartFetchSuccess({required this.data});
}
