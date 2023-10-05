part of 'withdraw_cubit.dart';

@immutable
class WithdrawState {}

class WithdrawInitial extends WithdrawState {
  final int amount;

  WithdrawInitial({required this.amount});
}

class HomeFindAccountInitial extends WithdrawState {}

class HomeFindAccountError extends WithdrawState {
  final AppBaseResponse res;

  HomeFindAccountError(this.res);
}

class HomeFindAccountSuccess extends WithdrawState {
  final Account account;

  HomeFindAccountSuccess({required this.account});
}
