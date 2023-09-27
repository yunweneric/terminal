part of 'transaction_cubit.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionFetchInitial extends TransactionState {}

class TransactionFetchError extends TransactionState {
  final AppBaseResponse response;

  TransactionFetchError(this.response);
}

class TransactionFetchSuccess extends TransactionState {
  final List<AppTransaction> transactions;

  TransactionFetchSuccess(this.transactions);
}

class TransactionFilterSuccess extends TransactionState {
  final List<AppTransaction> transactions;

  TransactionFilterSuccess(this.transactions);
}

class TransactionGeneratePdfInitial extends TransactionState {}

class TransactionGeneratePdfError extends TransactionState {
  final String message;

  TransactionGeneratePdfError(this.message);
}

class TransactionGeneratePdfSuccess extends TransactionState {
  final XFile file;

  TransactionGeneratePdfSuccess(this.file);
}

class TransactionAddInitial extends TransactionState {}

class TransactionAddError extends TransactionState {
  final AppBaseResponse response;

  TransactionAddError(this.response);
}

class TransactionAddSuccess extends TransactionState {
  final AppTransaction transaction;

  TransactionAddSuccess(this.transaction);
}
