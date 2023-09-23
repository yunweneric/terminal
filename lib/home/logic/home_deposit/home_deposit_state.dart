part of 'home_deposit_cubit.dart';

@immutable
abstract class HomeDepositState {}

class HomeDepositInitial extends HomeDepositState {}

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
