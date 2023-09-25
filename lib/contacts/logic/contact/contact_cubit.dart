import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:xoecollect/contacts/data/contact_service.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());
  List<Account> init_contacts = [];
  ContactService _contactService = ContactService();

  initialize(List<Account> contacts) {
    emit(ContactInitial());
  }

  void getAccounts(BuildContext context) async {
    emit(ContactFetchInitial());
    try {
      AppBaseResponse response = await _contactService.getAccounts(context);
      if (response.statusCode == 200 || response.statusCode == 201) {
        List<Map<String, dynamic>> data = response.data['data'];
        List<Account> app_data = data.map((e) => Account.fromJson(e)).toList();
        init_contacts = app_data;
        emit(ContactFetchSuccess(app_data));
      } else
        emit(ContactFetchError(response));
    } catch (error) {
      logError(error);
      emit(ContactFetchError(_contactService.apiServerError()));
    }
  }

  filter(String word) {
    List<Account> filtered_contacts = init_contacts.where((e) => e.name.toLowerCase().contains(word.toLowerCase())).toList();
    emit(ContactFiltered(filtered_contacts));
  }
}
