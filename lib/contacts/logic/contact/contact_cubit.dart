import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());
  List<Account> init_contacts = List.generate(20, (int index) => Account.fake());

  initialize(List<Account> contacts) {
    emit(ContactInitial());
  }

  getAccounts() {
    emit(ContactFetchInitial(init_contacts));
  }

  filter(String word) {
    List<Account> filtered_contacts = init_contacts.where((e) => e.name.toLowerCase().contains(word.toLowerCase())).toList();
    emit(ContactFiltered(filtered_contacts));
  }
}
