part of 'home_deposit_cubit.dart';

@immutable
abstract class HomeDepositState {}

class HomeDepositInitial extends HomeDepositState {
  final int amount;

  HomeDepositInitial({required this.amount});
}

class HomeDepositAdded extends HomeDepositState {
  final int amount;

  HomeDepositAdded({required this.amount});
}

class HomeDepositMinus extends HomeDepositState {
  final int amount;

  HomeDepositMinus({required this.amount});
}

class HomeDepositChangeAddFactor extends HomeDepositState {
  final int factor;

  HomeDepositChangeAddFactor({required this.factor});
}

class HomeFindAccountInitial extends HomeDepositState {}

class HomeFindAccountError extends HomeDepositState {
  final AppBaseResponse res;

  HomeFindAccountError(this.res);
}

class HomeFindAccountSuccess extends HomeDepositState {
  final Account account;

  HomeFindAccountSuccess({required this.account});
}
