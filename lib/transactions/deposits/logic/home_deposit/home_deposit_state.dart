part of 'home_deposit_cubit.dart';

@immutable
abstract class HomeDepositState {}

class HomeDepositInitial extends HomeDepositState {
  final int amount;

  HomeDepositInitial({required this.amount});
}

class HomeDepositAddedValue extends HomeDepositState {
  final int amount;
  final int factor;

  HomeDepositAddedValue({required this.amount, required this.factor});
}

class HomeDepositChangeOperator extends HomeDepositState {}

class HomeFindAccountInitial extends HomeDepositState {}

class HomeFindAccountError extends HomeDepositState {
  final AppBaseResponse res;

  HomeFindAccountError(this.res);
}

class HomeFindAccountSuccess extends HomeDepositState {
  final Account account;

  HomeFindAccountSuccess({required this.account});
}
