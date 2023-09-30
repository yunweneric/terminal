part of 'profile_cubit.dart';

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileFetchDataInit extends ProfileState {}

class ProfileFetchDataError extends ProfileState {
  final AppBaseResponse res;

  ProfileFetchDataError({required this.res});
}

class ProfileFetchDataSuccess extends ProfileState {
  final AppUser res;

  ProfileFetchDataSuccess({required this.res});
}
