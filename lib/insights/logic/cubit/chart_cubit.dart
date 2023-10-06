import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pinput/pinput.dart';
import 'package:xoecollect/contacts/logic/contact/contact_cubit.dart';
import 'package:xoecollect/insights/data/model/chart_group_model.dart';
import 'package:xoecollect/insights/data/model/chart_response.dart';
import 'package:xoecollect/insights/data/services/chart_service.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
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
        List<Map<String, dynamic>> raw_trans = res.data['data'];
        List<AppTransaction> all_trans = raw_trans.map((e) => AppTransaction.fromJson(e)).toList();

        // * Get only successful transactions
        // List<AppTransaction> success_trans = all_trans.where((element) => element.status == AppTransactionStatus.SUCCESS).toList();

        // logI(success_trans);
        // success_trans.forEach((element) {});
        // print(raw_trans.sublist(5));

        GetChartDataResponse? chart_data = sumDailyTransaction(all_trans, all_trans);
        // logI(chart_data);
        if (chart_data == null) {
          emit(ChartFetchError());
          return;
        }
        emit(ChartFetchSuccess(data: chart_data));

        // * Sum up all the transactions for each day

        // List<ChartGroupData> chart_data = raw_trans.map((e) => ChartGroupData(x, y1, y2)).toList();
      }
    } catch (e) {}
  }

  GetChartDataResponse? sumDailyTransaction(List<AppTransaction> deposits, List<AppTransaction> withdrawals) {
    try {
      double range = 10;
      double deposit_data_max = 0;
      double withdrawal_data_max = 0;
      List<List<AppTransaction>> withdrawals_group = groupTransactionsByDate(deposits);
      List<List<AppTransaction>> deposits_group = groupTransactionsByDate(deposits);

      List<ChartGroupData> deposit_data = deposits_group.map((e) {
        int sum_val = e.fold(0, (previousValue, element) => element.amount + previousValue);

        ChartGroupData chart_data = ChartGroupData(e.first.createdAt.weekday - 1, sum_val.toDouble(), 0);
        // logI(chart_data.toJson());
        return ChartGroupData(e.first.createdAt.weekday - 1, sum_val.toDouble(), 0);
      }).toList();

      List<ChartGroupData> withdrawal_data = withdrawals_group.map((e) {
        int sum_val = e.fold(0, (previousValue, element) => element.amount + previousValue);
        ChartGroupData chart_data = ChartGroupData(e.first.createdAt.weekday - 1, sum_val.toDouble(), 0);
        // logI(chart_data.toJson());
        return ChartGroupData(e.first.createdAt.weekday - 1, sum_val.toDouble(), 0);
      }).toList();

      withdrawal_data_max = getMaxValue(withdrawal_data);
      deposit_data_max = getMaxValue(deposit_data);

      // return withdrawal_data.map((e) => GetChartDataResponse(data: withdrawal_data, max_value: withdrawal_data_max, range: 10)).toList();
      return GetChartDataResponse(data: withdrawal_data, max_value: withdrawal_data_max, range: range);

      // List<int> sum = grouped_data.map((e) => e.fold(0, (previousValue, element) => element.amount + previousValue)).toList();
      // return sum;
      // ChartGroupData(x, y1, y2)
    } catch (e) {
      logError(e);
      return null;
    }
  }

  double getMaxValue(List<ChartGroupData> data) {
    List<double> max_values = data.map((e) => e.y1).toList();
    max_values.sort();
    if (max_values.isEmpty) return 0;
    return max_values.first;
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
