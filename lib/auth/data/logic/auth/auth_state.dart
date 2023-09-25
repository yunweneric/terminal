part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthPhoneLoginInit extends AuthState {}

class AuthPhoneLoginError extends AuthState {
  final AppBaseResponse res;

  AuthPhoneLoginError(this.res);
}

class AuthPhoneLoginSuccess extends AuthState {
  final AppBaseResponse res;

  AuthPhoneLoginSuccess(this.res);
}

class AuthVerifyOTPInit extends AuthState {}

class AuthVerifyOTPError extends AuthState {
  final AppBaseResponse res;

  AuthVerifyOTPError(this.res);
}

class AuthVerifyOTPSuccess extends AuthState {
  final AppUser res;

  AuthVerifyOTPSuccess(this.res);
}

class AuthAddPinInit extends AuthState {}

class AuthAddPinError extends AuthState {
  final AppBaseResponse res;

  AuthAddPinError(this.res);
}

class AuthAddPinSuccess extends AuthState {
  final String pin;
  AuthAddPinSuccess(this.pin);
}

class AuthResetPasswordInit extends AuthState {}

class AuthResetPasswordError extends AuthState {
  final AppBaseResponse res;

  AuthResetPasswordError(this.res);
}

class AuthResetPasswordSuccess extends AuthState {
  final AppBaseResponse res;
  AuthResetPasswordSuccess(this.res);
}

class AuthVerifyPinInit extends AuthState {}

class AuthVerifyPinError extends AuthState {
  final AppBaseResponse res;

  AuthVerifyPinError(this.res);
}

class AuthVerifyPinSuccess extends AuthState {
  final bool res;
  AuthVerifyPinSuccess(this.res);
}

class AuthHidePin extends AuthState {
  AuthHidePin();
}

class AuthCreateNewPinInit extends AuthState {}

class AuthCreateNewPinError extends AuthState {
  final AppBaseResponse res;

  AuthCreateNewPinError(this.res);
}

class AuthCreateNewPinSuccess extends AuthState {
  final AppUser res;
  AuthCreateNewPinSuccess(this.res);
}
