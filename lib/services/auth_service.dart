import 'package:flutter/src/widgets/framework.dart';
import 'package:xoecollect/models/auth/login_req_model.dart';
import 'package:xoecollect/models/auth/reset_pin_req_model.dart';
import 'package:xoecollect/models/base/base_res_model.dart';
import 'package:xoecollect/services/base_service.dart';

class AuthService extends BaseService {
  Future<AppBaseResponse> phoneLogin(BuildContext context, LoginRequestModel model) async {
    return basePost(data: model.toJson(), urlPath: "/api/account", isSimpleHeaders: true);
  }

  Future<AppBaseResponse> verifyCode(BuildContext context, String otpCode, bool isNew) {
    if (isNew) {
      return baseGet(urlPath: "/api/account/verify/code/NEW/${otpCode}");
    }
    return baseGet(urlPath: "/api/account/verify/code/RESET/${otpCode}");
  }

  Future<AppBaseResponse> createPin(BuildContext context, ResetPinReqModel data) async {
    // return basePut(data: data.toJson(), urlPath: "/api/clients/pin");
    return baseGet(urlPath: "/api/account/verify/code/RESET/}");
  }

  Future<AppBaseResponse> resetPassword(BuildContext context, String phone) async {
    return basePost(data: {"phone": phone}, urlPath: "/api/clients/forgot/pin", isSimpleHeaders: true);
  }
}
