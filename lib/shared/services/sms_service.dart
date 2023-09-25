import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';

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
      return basePost(data: data, urlPath: url);
    } catch (e) {
      return apiServerError();
    }
  }
}
