import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xoecollect/config/app_config.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/collection_service.dart';

class ChartService extends BaseService {
  Future<AppBaseResponse> getChartData() async {
    Timestamp now = Timestamp.now();
    DateTime date = DateTime.now().subtract(Duration(days: 6));
    Timestamp last_week = Timestamp.fromDate(date);
    final collection = await AppConfig.getCollection(AppCollections.TRANSACTIONS);
    return baseQuery(
      name: "chart",
      query: await collection.where('createdAt', isGreaterThan: last_week).where("createdAt", isLessThanOrEqualTo: now).get(),
    );
  }
}
