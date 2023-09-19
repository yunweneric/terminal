import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xoecollect/models/auth/login_req_model.dart';
import 'package:xoecollect/models/auth/reset_pin_req_model.dart';
import 'package:xoecollect/models/auth/token_res.dart';
import 'package:xoecollect/models/auth/verification_res_model.dart';
import 'package:xoecollect/models/base/base_res_model.dart';
import 'package:xoecollect/services/auth_service.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthService authService = AuthService();
  AuthCubit() : super(AuthInitial());

  void phoneLogin(BuildContext context, LoginRequestModel model) async {
    try {
      emit(AuthPhoneLoginInit());
      AppBaseResponse res = await authService.phoneLogin(context, model);
      if (res.statusCode == 200) {
        emit(AuthPhoneLoginSuccess(AuthResponseModel.fromJson(res.data)));
      } else {
        emit(AuthPhoneLoginError(res));
      }
    } catch (e) {
      logError(["phoneLogin", e]);
      emit(AuthPhoneLoginError(authService.apiServerError()));
    }
  }

  verifyCode(BuildContext context, String otpCode, bool isNew) async {
    logI(isNew);
    try {
      emit(AuthVerifyOTPInit());
      AppBaseResponse res = await authService.verifyCode(context, otpCode, isNew);
      if (res.statusCode == 200) {
        emit(AuthVerifyOTPSuccess(VerificationResponseModel.fromJson(res.data)));
      } else {
        emit(AuthVerifyOTPError(res));
      }
    } catch (e) {
      logError(["Error verifyCode", e]);
      emit(AuthVerifyOTPError(authService.apiServerError()));
    }
  }

  Future createPin(BuildContext context, ResetPinReqModel data) async {
    try {
      emit(AuthAddPinInit());
      AppBaseResponse res = await authService.createPin(context, data);
      if (res.statusCode == 200) {
        emit(AuthAddPinSuccess(res));
      } else {
        emit(AuthAddPinError(res));
      }
    } catch (e) {
      logError(["Error createPin", e]);
      emit(AuthAddPinError(authService.apiServerError()));
    }
  }

  Future<void> resetPassword(String phone, BuildContext context) async {
    try {
      emit(AuthResetPasswordInit());
      AppBaseResponse res = await authService.resetPassword(context, phone);
      if (res.statusCode == 200) {
        emit(AuthResetPasswordSuccess(res));
      } else {
        emit(AuthResetPasswordError(res));
      }
    } catch (e) {
      logError(["Error createPin", e]);
      emit(AuthResetPasswordError(authService.apiServerError()));
    }
  }
}
