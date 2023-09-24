import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xoecollect/invoice/services/invoice_generator.dart';
import 'package:xoecollect/invoice/services/pdf_service.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

part 'home_deposit_state.dart';

class HomeDepositCubit extends Cubit<HomeDepositState> {
  HomeDepositCubit() : super(HomeDepositInitial(amount: 500));
  int initial_amount = 500;
  int add_factor = 500;
  // PdfApi _pdfApi =PdfApi("filename");
  addAmount(int amount) {
    initial_amount += amount;
    emit(HomeDepositAdded(amount: initial_amount));
  }

  minusAmount(int amount) {
    initial_amount -= amount;
    if (initial_amount < 0) initial_amount = 0;
    emit(HomeDepositAdded(amount: initial_amount));
  }

  changeAddFactor(int factor) {
    add_factor = factor;
    emit(HomeDepositChangeAddFactor(factor: add_factor));
  }

  generatePdf(String transactionId, int amount, String phoneNumber) async {
    try {
      XFile? file = await InvoiceGenerator.generate(AppTransaction.fake());
      if (file != null) {
        PdfApi.printFile(file);
      }
    } catch (e) {
      logError("Error generating pdf: ${e}");
    }
  }
}
