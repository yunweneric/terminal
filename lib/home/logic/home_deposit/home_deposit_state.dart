part of 'home_deposit_cubit.dart';

@immutable
abstract class HomeDepositState {}

class HomeDepositInitial extends HomeDepositState {
  final int amount;

  HomeDepositInitial({required this.amount});
}

class HomeDepositAddedValue extends HomeDepositState {
  final int amount;

  HomeDepositAddedValue({required this.amount});
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
