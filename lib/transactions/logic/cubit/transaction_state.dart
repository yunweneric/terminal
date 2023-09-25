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

class TransactionGeneratePdfInitial extends TransactionState {}

class TransactionGeneratePdfError extends TransactionState {
  final String message;

  TransactionGeneratePdfError(this.message);
}

class TransactionGeneratePdfSuccess extends TransactionState {
  final XFile file;

  TransactionGeneratePdfSuccess(this.file);
}
