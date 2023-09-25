part of 'contact_cubit.dart';

@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactFiltered extends ContactState {
  final List<Account> contacts;

  ContactFiltered(this.contacts);
}

class ContactFetchError extends ContactState {
  final AppBaseResponse response;

  ContactFetchError(this.response);
}

class ContactFetchInitial extends ContactState {}

class ContactFetchSuccess extends ContactState {
  final List<Account> accounts;

  ContactFetchSuccess(this.accounts);
}
