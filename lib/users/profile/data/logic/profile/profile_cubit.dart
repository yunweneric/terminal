import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/users/profile/data/services/profile_service.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  ProfileService profileService = ProfileService();

  void fetchUserData(BuildContext context) async {
    try {
      emit(ProfileFetchDataInit());
      AppBaseResponse res = await profileService.findProfileData(context);
      res.statusCode == 200 ? emit(ProfileFetchDataSuccess(res: AppUser.fromJson(res.data))) : emit(ProfileFetchDataError(res: res));
    } catch (e) {
      logI(["Profile cubit fetchProfileData ", e]);
      emit(ProfileFetchDataError(res: profileService.apiServerError()));
    }
  }

  void updateProfilePicture(BuildContext context, String path) {}
}
