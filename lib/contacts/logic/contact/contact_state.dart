part of 'contact_cubit.dart';

@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactFetchInitial extends ContactState {
  final List<Account> contacts;

  ContactFetchInitial(this.contacts);
}

class ContactFiltered extends ContactState {
  final List<Account> contacts;

  ContactFiltered(this.contacts);
}
