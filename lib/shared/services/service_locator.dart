import 'package:get_it/get_it.dart';
import 'package:xoecollect/contacts/data/contact_service.dart';
import 'package:xoecollect/insights/data/services/chart_service.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/sms_service.dart';
import 'package:xoecollect/transactions/data/transaction_service.dart';

class ServiceLocator {
  static final getIt = GetIt.instance;

  static setup() {
    getIt.registerSingleton<BaseService>(BaseService());
    getIt.registerSingleton<SMSService>(SMSService());
    getIt.registerSingleton<ContactService>(ContactService());
    getIt.registerSingleton<TransactionService>(TransactionService());
    getIt.registerSingleton<ChartService>(ChartService());
  }
}
