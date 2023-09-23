import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'home_deposit_state.dart';

class HomeDepositCubit extends Cubit<HomeDepositState> {
  HomeDepositCubit() : super(HomeDepositInitial());
  int initial_amount = 500;
  int add_factor = 500;
  addAmount(int amount) {
    initial_amount += amount;
    emit(HomeDepositAdded(amount: initial_amount));
  }

  minusAmount(int amount) {
    initial_amount -= amount;
    emit(HomeDepositAdded(amount: initial_amount));
  }

  changeAddFactor(int factor) {
    add_factor = factor;
    emit(HomeDepositChangeAddFactor(factor: add_factor));
  }
}
