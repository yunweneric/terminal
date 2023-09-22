import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/data/model/reset_pin_req_model.dart';
import 'package:xoecollect/auth/data/model/verification_routing.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

class AuthService extends BaseService {
  Future<void> phoneLogin(BuildContext context, String userPhone) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: userPhone,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        AppBaseResponse res = apiError(message: e.message ?? "Verification code could not be sent. Please try again later!", data: {});
        listenPhoneLogin(res, context);
      },
      codeSent: (String verificationId, int? resendToken) async {
        final data = VerificationParams(phone: userPhone, verificationId: verificationId, resendToken: resendToken);
        await LocalPreferences.saveVerificationData(data);
        AppBaseResponse res = apiSuccess(message: "Login Successful", data: data.toJson());
        listenPhoneLogin(res, context);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        logError("codeAutoRetrievalTimeout: $verificationId");
      },
    );
  }

  listenPhoneLogin(AppBaseResponse res, BuildContext context) {
    BlocProvider.of<AuthCubit>(context).listenFirebaseLogin(context, res);
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
