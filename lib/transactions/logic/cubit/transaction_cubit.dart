import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:xoecollect/invoice/services/invoice_generator.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/transactions/data/transaction_service.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  TransactionService _transactionService = TransactionService();
  void fetchTransactions(BuildContext context) async {
    emit(TransactionFetchInitial());
    try {
      AppBaseResponse response = await _transactionService.getTransactions();
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Map<String, dynamic>> data = response.data['data'];
        List<AppTransaction> app_data = data.map((e) => AppTransaction.fromJson(e)).toList();
        emit(TransactionFetchSuccess(app_data));
      } else
        emit(TransactionFetchError(response));
    } catch (error) {
      logError(error);
      emit(TransactionFetchError(_transactionService.apiServerError()));
    }
  }

  generatePdf(String transactionId, int amount, String phoneNumber) async {
    emit(TransactionGeneratePdfInitial());
    try {
      XFile? file = await InvoiceGenerator.generate(AppTransaction.fake());
      if (file != null) {
        emit(TransactionGeneratePdfSuccess(file));
      } else
        emit(TransactionGeneratePdfError("We encountered an error while generating the invoice!"));
    } catch (e) {
      emit(TransactionGeneratePdfError("We encountered an error while generating the invoice!"));

      logError("Error generating pdf: ${e}");
    }
  }

  void addTransaction({required BuildContext context, required AppTransaction data}) async {
    emit(TransactionAddInitial());
    try {
      AppBaseResponse response = await _transactionService.addTransaction(context, data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(TransactionAddSuccess(data));
      } else
        emit(TransactionAddError(response));
    } catch (error) {
      logError(error);
      emit(TransactionAddError(_transactionService.apiServerError()));
    }
  }
}
