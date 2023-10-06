import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:xoecollect/config/app_config.dart';
import 'package:xoecollect/invoice/services/invoice_generator.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/collection_service.dart';
import 'package:xoecollect/shared/services/sms_service.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/transactions/data/transaction_service.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());

  TransactionService _transactionService = TransactionService();
  SMSService smsService = SMSService();
  BaseService base_service = BaseService();
  bool has_subscription = false;
  List<AppTransaction> all_transactions = [];

  Stream<QuerySnapshot<Map<String, dynamic>>>? transactionStream;

  initStream() async {
    final collectionReference = await AppConfig.getCollection(AppCollections.TRANSACTIONS);
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = collectionReference.snapshots();
    transactionStream = snapshots;
    subscribeToTransactions();
    has_subscription = true;
  }

  void fetchTransactions(BuildContext context) async {
    // if (!has_subscription) initStream();
    initStream();
    // emit(TransactionFetchInitial());
    // try {
    //   AppBaseResponse response = await _transactionService.getTransactions();
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     List<Map<String, dynamic>> data = response.data['data'];
    //     List<AppTransaction> app_data = data.map((e) => AppTransaction.fromJson(e)).toList();
    //     emit(TransactionFetchSuccess(app_data));
    //   } else
    //     emit(TransactionFetchError(response));
    // } catch (error) {
    //   logError(error);
    //   emit(TransactionFetchError(_transactionService.apiServerError()));
    // }
  }

  Future subscribeToTransactions() async {
    transactionStream?.listen((event) {
      logI(event);
      List<Map<String, dynamic>> response = event.docs.map((e) => e.data()).toList();
      List<AppTransaction> app_data = response.map((e) => AppTransaction.fromJson(e)).toList();
      app_data.sort(((a, b) => b.createdAt.compareTo(a.createdAt)));
      all_transactions = app_data;
      emit(TransactionFetchSuccess(app_data));
    }).onError((e) {
      final response = _transactionService.apiError(message: e.toString());
      emit(TransactionFetchError(response));
    });
  }

  unSubscribeToTransactions() {
    // transactionStream?.
  }

  generatePdfFile(String transactionId, int amount, String phoneNumber) async {
    emit(TransactionGeneratePdfInitial());
    try {
      XFile? file = await InvoiceGenerator.generateFile(AppTransaction.fake());
      if (file != null) {
        emit(TransactionGeneratePdfSuccess(file));
      } else
        emit(TransactionGeneratePdfError("We encountered an error while generating the invoice!"));
    } catch (e) {
      emit(TransactionGeneratePdfError("We encountered an error while generating the invoice!"));

      logError("Error generating pdf: ${e}");
    }
  }

  // generateAppPdf(String transactionId, int amount, String phoneNumber) async {
  //   emit(TransactionGeneratePdfInitial());
  //   try {
  //     XFile? file = await InvoiceGenerator.generate(AppTransaction.fake());
  //     if (file != null) {
  //       emit(TransactionGeneratePdfSuccess(file));
  //     } else
  //       emit(TransactionGeneratePdfError("We encountered an error while generating the invoice!"));
  //   } catch (e) {
  //     emit(TransactionGeneratePdfError("We encountered an error while generating the invoice!"));

  //     logError("Error generating pdf: ${e}");
  //   }
  // }

  void addTransaction({required BuildContext context, required AppTransaction data, required bool isDeposit}) async {
    emit(TransactionAddInitial());
    try {
      AppBaseResponse response = await _transactionService.addTransaction(context, data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppTransaction updated = data;
        String date = Formaters.formatDate(data.createdAt);
        if (data.transaction_type == AppTransactionType.DEPOSIT) {
          updated.status = AppTransactionStatus.SUCCESS;
        } else if (data.transaction_type == AppTransactionType.WITHDRAW) {
          updated.status = AppTransactionStatus.PENDING;
        }
        var sms_res = await smsService.sendSMS(
          "+237670912935",
          isDeposit == true
              ? "You have successfully deposited a sum of ${data.amount} FCFA to ${data.name} with account ID ${data.account_num}\n\nTransaction ID: ${data.transaction_id}\nDate: ${date}"
              : "${data.name} is wants to withdraw a sum of ${data.amount} FCFA from your account. You can confirm using this code ${data.code}",
        );
        if (sms_res.statusCode == 200 || sms_res.statusCode == 201) {
          await base_service.baseUpdate(data: updated.toJson(), collectionRef: AppCollections.TRANSACTIONS);
          emit(TransactionAddSuccess(updated));
        } else {
          emit(TransactionAddError(sms_res));
        }
      } else
        emit(TransactionAddError(response));
    } catch (error) {
      logError(error);
      emit(TransactionAddError(_transactionService.apiServerError()));
    }
  }

  filter(String? filter) {
    if (filter == null) {
      emit(TransactionFilterSuccess(all_transactions));
      return;
    }
    final filtered_transaction = all_transactions.where((element) => element.transaction_type == filter).toList();
    emit(TransactionFilterSuccess(filtered_transaction));
    // logI([all_transactions.length, filtered_transaction.length]);
  }

  void reconcileTransaction({required BuildContext context, required AppTransaction data, required String code}) async {
    if (code != data.code) {
      AppBaseResponse res = _transactionService.apiError(data: {}, message: "The code you entered in incorrect");
      emit(TransactionReconcileError(res));
      return;
    }
    emit(TransactionReconcileInitial());
    try {
      AppTransaction updated = data;
      updated.status = AppTransactionStatus.SUCCESS;
      AppBaseResponse response = await _transactionService.baseUpdate(data: updated.toJson(), collectionRef: AppCollections.TRANSACTIONS);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(TransactionReconcileSuccess(updated));
      } else
        emit(TransactionReconcileError(response));
    } catch (error) {
      logError(error);
      emit(TransactionReconcileError(_transactionService.apiServerError()));
    }
  }
}
