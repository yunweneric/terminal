import 'package:flutter/src/widgets/framework.dart';
import 'package:xoecollect/contacts/data/contact_service.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/collection_service.dart';

class DepositService extends ContactService {
  Future<AppBaseResponse> findUserAccount(String val, BuildContext context) async {
    return baseFind(collectionRef: AppCollections.ACCOUNTS, field: "id", value: val, name: "Account");
  }
}
