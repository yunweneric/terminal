import 'package:faker/faker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/collection_service.dart';

class ContactService extends BaseService {
  Future<AppBaseResponse> seedContact() async {
    List<Account> accounts = List.generate(20, (index) {
      Faker faker = Faker();
      return Account.fake(faker);
    });
    for (var account in accounts) {
      baseAdd(data: account.toJson(), collectionRef: AppCollections.ACCOUNTS);
    }
    return apiSuccess(message: "Data seeded", data: {"data": accounts});
  }

  Future<AppBaseResponse> getAccounts(BuildContext context) async {
    return baseGet(collectionRef: AppCollections.ACCOUNTS);
  }
}
