import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:xoecollect/insights/data/model/chart_group_model.dart';
import 'package:xoecollect/insights/data/model/chart_response.dart';
import 'package:xoecollect/insights/data/services/chart_service.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

part 'chart_state.dart';

class ChartCubit extends Cubit<ChartState> {
  final ChartService chartService;
  ChartCubit({required this.chartService}) : super(ChartInitial());

  void getCharData(BuildContext context) async {
    emit(ChartFetchInitial());
    try {
      var res = await chartService.getChartData();
      if (res.statusCode == 200) {
        if (res.data.isEmpty) {
          emit(ChartFetchSuccess(data: GetChartDataResponse.empty()));
          return;
        }
        List<Map<String, dynamic>> raw_trans = res.data['data'];
        List<AppTransaction> all_trans = raw_trans.map((e) => AppTransaction.fromJson(e)).toList();

        logI(all_trans);
        // * Get only successful transactions
        List<AppTransaction> success_trans = all_trans.where((element) => element.status == AppTransactionStatus.SUCCESS).toList();

        // logI(success_trans);
        // success_trans.forEach((element) {});
        // print(raw_trans.sublist(5));

        List<AppTransaction> deposits = success_trans.where((element) => element.transaction_type == AppTransactionType.DEPOSIT).toList();
        List<AppTransaction> withdrawal = success_trans.where((element) => element.transaction_type == AppTransactionType.WITHDRAW).toList();
        GetChartDataResponse? chart_data = sumDailyTransaction(deposits, withdrawal);
        if (chart_data == null) {
          emit(ChartFetchError());
          return;
        }
        emit(ChartFetchSuccess(data: chart_data));

        // * Sum up all the transactions for each day

        // List<ChartGroupData> chart_data = raw_trans.map((e) => ChartGroupData(x, y1, y2)).toList();
      }
    } catch (e) {
      logError(e);
    }
  }

  GetChartDataResponse? sumDailyTransaction(List<AppTransaction> deposits, List<AppTransaction> withdrawals) {
    try {
      double range = 0;
      double deposit_data_max = 0;
      double withdrawal_data_max = 0;
      List<List<AppTransaction>> withdrawals_group = groupTransactionsByDate(withdrawals);
      List<List<AppTransaction>> deposits_group = groupTransactionsByDate(deposits);

      List<ChartGroupData> deposit_data = deposits_group.map((e) {
        int sum_val = e.fold(0, (previousValue, element) => element.amount + previousValue);

        return ChartGroupData(e.first.createdAt.weekday - 1, sum_val.toDouble(), 0);
      }).toList();

      List<ChartGroupData> withdrawal_data = withdrawals_group.map((e) {
        int sum_val = e.fold(0, (previousValue, element) => element.amount + previousValue);
        return ChartGroupData(e.first.createdAt.weekday - 1, sum_val.toDouble(), sum_val.toDouble());
      }).toList();

      withdrawal_data_max = getMaxWithdrawal(withdrawal_data);
      deposit_data_max = getMaxDeposit(deposit_data);
      double calculated_max_value = withdrawal_data_max > deposit_data_max ? withdrawal_data_max : deposit_data_max;
      range = generateRange(calculated_max_value.round());

      logD(["withdrawal_data_max", withdrawal_data_max, "deposit_data_max", deposit_data_max, "calculated_max_value", calculated_max_value]);

      List<ChartGroupData> combinedData = [];
      for (var i = 0; i < deposit_data.length; i++) {
        combinedData.add(ChartGroupData(deposit_data[i].x, deposit_data[i].y1, withdrawal_data[i].y2));
      }
      return GetChartDataResponse(data: combinedData, max_value: calculated_max_value, range: range);
    } catch (e) {
      logError(e);
      return null;
    }
  }

  double generateRange(int maxValue) {
    // Ensure the maximum value is greater than or equal to 10
    if (maxValue < 10) {
      return 1.0;
    }

    // Calculate the step size between values
    int step = (maxValue / 9).floor();

    return step.toDouble();
  }

  double getMaxDeposit(List<ChartGroupData> data) {
    List<double> max_values = data.map((e) => e.y1).toList();
    max_values.sort();
    if (max_values.isEmpty) return 0;
    return max_values.last;
  }

  double getMaxWithdrawal(List<ChartGroupData> data) {
    List<double> max_values = data.map((e) => e.y2).toList();
    max_values.sort();
    if (max_values.isEmpty) return 0;
    return max_values.last;
  }

  List<List<AppTransaction>> groupTransactionsByDate(List<AppTransaction> transactions) {
    final Map<DateTime, List<AppTransaction>> groupedTransactions = {};

    transactions.forEach((transaction) {
      final DateTime transactionDate = transaction.createdAt;
      final date = DateTime(transactionDate.year, transactionDate.month, transactionDate.day);

      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }

      groupedTransactions[date]?.add(transaction);
    });
    final result = groupedTransactions.values.toList();
    return result;
  }
}
