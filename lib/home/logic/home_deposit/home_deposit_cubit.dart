import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';
import 'package:xoecollect/home/services/deposit_service.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

part 'home_deposit_state.dart';

class HomeDepositCubit extends Cubit<HomeDepositState> {
  HomeDepositCubit() : super(HomeDepositInitial(amount: 500));
  int initial_amount = 500;
  int add_factor = 0;
  String message = "Please type to select account";
  bool loading = false;
  bool error = true;
  bool isAdditionOperator = true;
  bool isFirstClick = true;
  List<dynamic> compute = [];
  Account? account;
  // List<dynamic> input = [0, '+', 0, '+', 4, '+', 1, '+', 0];

  DepositService _depositService = DepositService();

  void addOperator({required bool isAddition}) {
    isFirstClick = compute.length == 0 ? true : false;
    if (isFirstClick) {
      initial_amount = 0;
      emit(HomeDepositAddedValue(amount: initial_amount));
    } else if (compute.length > 0) {
      logI("addOperator is ${isAddition} and last item is: ${compute.last.runtimeType}");
      isAdditionOperator = isAddition;
    }
    // logI([isAddition, compute]);
    print("-------------------");
    print(compute);
    print("-------------------");
  }

  void addValue(int value) {
    print("--------INnit-----------");
    print(compute);
    print("-------------------");
    isFirstClick = compute.length == 0 ? true : false;
    if (isFirstClick) {
      initial_amount = 0;
      compute.add(value);
      emit(HomeDepositAddedValue(amount: initial_amount));
    }

    if (compute.length > 0) {
      logI("Value is ${value} and last item is: ${compute.last.runtimeType}");
      isAdditionOperator ? compute.add(value) : compute.add(-value);
      initial_amount = calculateExpression(compute);
      emit(HomeDepositAddedValue(amount: initial_amount));
    } else {
      compute.add(value);
      initial_amount = calculateExpression(compute);
      emit(HomeDepositAddedValue(amount: initial_amount));
    }
    print("-------------------");
    print(compute);
    print("-------------------");
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

  int calculateExpression(List<dynamic> input) {
    if (input.isEmpty) {
      logError("Input is empty");
      return 0;
    }

    double result = input[0].toDouble(); // Initialize result with the first number

    // Iterate through the array starting from the second element
    for (int i = 1; i < input.length; i += 2) {
      if (i + 1 >= input.length) {
        logError("Input array is not well-formed");
        return 0;
      }

      // Get the operator and the next number
      String operator = input[i];
      double nextNumber = input[i + 1].toDouble();

      // Perform calculations based on the operator
      if (operator == '+') {
        result += nextNumber;
      } else if (operator == '-') {
        result -= nextNumber;
      } else {
        logError("Invalid operator: $operator");
        return 0;
      }
    }
    logI(result);
    return result.toInt();
  }

  void updateSum(String val) {
    initial_amount = int.parse(val);
  }
}
