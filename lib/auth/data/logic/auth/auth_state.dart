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
  final AuthResponseModel res;

  AuthPhoneLoginSuccess(this.res);
}

class AuthVerifyOTPInit extends AuthState {}

class AuthVerifyOTPError extends AuthState {
  final AppBaseResponse res;

  AuthVerifyOTPError(this.res);
}

class AuthVerifyOTPSuccess extends AuthState {
  final VerificationResponseModel res;

  AuthVerifyOTPSuccess(this.res);
}

class AuthAddPinInit extends AuthState {}

class AuthAddPinError extends AuthState {
  final AppBaseResponse res;

  AuthAddPinError(this.res);
}

class AuthAddPinSuccess extends AuthState {
  final AppBaseResponse res;
  AuthAddPinSuccess(this.res);
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