import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';
import 'package:xoecollect/home/services/deposit_service.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

part 'home_deposit_state.dart';

class HomeDepositCubit extends Cubit<HomeDepositState> {
  HomeDepositCubit() : super(HomeDepositInitial(amount: 500)) {
    amountController.text = '500';
  }
  int total_amount = 500;
  int add_factor = 25;
  String message = "Please type to select account";
  bool loading = false;
  bool error = false;
  bool isAdditionOperator = true;
  bool isFirstClick = true;
  List<int> compute = [];
  Account? account;
  List<int> amounts = [25, 50, 100, 200, 500, 1000, 2000, 2500, 3000, 5000, 10000];

  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DepositService _depositService = DepositService();

  void addOperator({required bool isAddition}) {
    isAdditionOperator = isAddition;
    emit(HomeDepositChangeOperator());
  }

  void addValue(int value) {
    isFirstClick = compute.length == 0 ? true : false;
    add_factor = value;
    if (isFirstClick) {
      compute.add(0);
      amountController.text = "0";
      emit(HomeDepositAddedValue(amount: total_amount, factor: value));
    }

    if (compute.length > 0) {
      isAdditionOperator ? compute.add(value) : compute.add(-value);
      total_amount = calculateExpression(compute);
      if (total_amount <= 0) {
        compute.clear();
        total_amount = 0;
      }
      amountController.text = total_amount.toString();
      emit(HomeDepositAddedValue(amount: total_amount, factor: value));
    }
  }

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
          logI(found_account.toJson());
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

  int calculateExpression(List<int> inputs) {
    return inputs.fold(0, (previousValue, element) => previousValue + element);
  }

  void updateSum(String val) {
    total_amount = int.parse(val);
  }
}
