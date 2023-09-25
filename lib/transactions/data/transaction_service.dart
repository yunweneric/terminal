import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/collection_service.dart';

class TransactionService extends BaseService {
  Future<AppBaseResponse> seedTransactions() async {
    List<AppTransaction> transactions = List.generate(30, (index) => AppTransaction.fake());
    for (var transaction in transactions) {
      baseAdd(data: transaction.toJson(), collectionRef: AppCollections.TRANSACTIONS);
    }
    return apiSuccess(message: "", data: {"data": transactions});
  }

  Future<AppBaseResponse> getTransactions() async {
    return baseGet(collectionRef: AppCollections.TRANSACTIONS);
  }
}
