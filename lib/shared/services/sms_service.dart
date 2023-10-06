import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

class SMSService extends BaseService {
  Future<AppBaseResponse> sendSMS(String phone, String message) async {
    String? url = await getBaseSMSURL();
    if (url == null) return apiServerError();
    try {
      Map<String, dynamic> data = {
        "sender": "BapCull",
        "recipient": phone,
        "text": message,
      };
      var res = await basePost(data: data, urlPath: url);
      logI(res.toJson());
      return res;
    } catch (e) {
      return apiServerError();
    }
  }
}
