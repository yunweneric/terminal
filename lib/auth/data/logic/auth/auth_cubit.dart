import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xoecollect/shared/helpers/encryptor.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/auth/data/services/auth_service.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthService authService = AuthService();
  AuthCubit() : super(AuthInitial());

  void phoneLogin(BuildContext context, String phone) async {
    emit(AuthPhoneLoginInit());
    authService.phoneLogin(context, phone);
  }

  void listenFirebaseLogin(BuildContext context, AppBaseResponse res) async {
    try {
      if (res.statusCode == 200) {
        emit(AuthPhoneLoginSuccess(res));
      } else {
        emit(AuthPhoneLoginError(res));
      }
    } catch (e) {
      logError(["phoneLogin", e]);
      emit(AuthPhoneLoginError(authService.apiServerError()));
    }
  }

  Future createPin(BuildContext context, String code) async {
    try {
      emit(AuthAddPinInit());
      String encryptedPin = EnCryptor.encryptPin(code);
      AppBaseResponse res = await authService.createPin(context, encryptedPin);
      if (res.statusCode == 200) {
        emit(AuthAddPinSuccess(encryptedPin));
      } else {
        emit(AuthAddPinError(res));
      }
    } catch (e) {
      logError(["Error createPin", e]);
      emit(AuthAddPinError(authService.apiServerError()));
    }
  }

  void phoneVerification({required BuildContext context, required String phone, required String smsCode, required String verificationId}) async {
    emit(AuthVerifyOTPInit());
    try {
      AppBaseResponse response = await authService.phoneVerification(context, smsCode, phone, verificationId);
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AuthVerifyOTPSuccess(AppUser.fromJson(response.data)));
      } else
        emit(AuthVerifyOTPError(response));
    } catch (error) {
      emit(AuthVerifyOTPError(authService.apiServerError()));
    }
  }

  void verifyPin(BuildContext context, String p) async {
    emit(AuthVerifyPinInit());
    try {
      AppBaseResponse response = await authService.verifyPin(context, p);
      logI(response.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AuthVerifyPinSuccess(response.data['data']));
      } else
        emit(AuthVerifyPinError(response));
    } catch (error) {
      logError(error);
      emit(AuthVerifyPinError(authService.apiServerError()));
    }
  }

  hidePin() {
    emit(AuthHidePin());
  }

  void createNewPin(BuildContext context, String pin, String uid) async {
    emit(AuthCreateNewPinInit());
    try {
      AppBaseResponse response = await authService.createNewPin(context, pin, uid);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AppUser user = AppUser.fromJson(response.data);
        await LocalPreferences.saveAllUserInfo(user);
        await LocalPreferences.savePin(user.password!);
        emit(AuthCreateNewPinSuccess(user));
      } else
        emit(AuthCreateNewPinError(response));
    } catch (error) {
      logError(error);
      emit(AuthCreateNewPinError(authService.apiServerError()));
    }
  }
}
