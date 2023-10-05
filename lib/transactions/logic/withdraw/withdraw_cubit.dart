import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/transactions/data/deposit_service.dart';

part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit() : super(WithdrawInitial(amount: 500)) {
    amountController.text = '500';
  }
  int total_amount = 500;
  String message = "Please type to select account";
  bool loading = false;
  bool error = false;
  Account? account;

  TextEditingController amountController = TextEditingController();
  DepositService _depositService = DepositService();
  TextEditingController accountController = TextEditingController();

  Future<void> findUser(String val, BuildContext context) async {
    emit(HomeFindAccountInitial());
    loading = true;
    error = false;
    try {
      AppBaseResponse res = await _depositService.findUserAccount(val, context);
      logI(res.toJson());
      if (res.statusCode == 200) {
        if (res.data.isNotEmpty) {
          message = res.message;
          Account found_account = Account.fromJson(res.data);
          account = found_account;
          emit(HomeFindAccountSuccess(account: found_account));
          loading = false;
          error = false;
        } else {
          message = res.message;
          loading = false;
          error = false;
          emit(HomeFindAccountError(res));
        }
      } else {
        loading = false;
        error = true;
        message = res.message;
        emit(HomeFindAccountError(res));
      }
    } catch (e) {
      message = _depositService.apiServerError().message;
      logI(e.toString());
      emit(HomeFindAccountError(_depositService.apiServerError()));
    }
  }

  void updateAmount(String val) {
    amountController.text = val;
    total_amount = int.parse(val);
  }
}
