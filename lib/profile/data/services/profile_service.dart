import 'package:flutter/material.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/users/data/services/user_service.dart';

class ProfileService extends UserService {
  Future<AppBaseResponse> findProfileData(BuildContext context) async {
    try {
      AppUser? user = await getCurrentUser();
      if (user == null) return apiError(message: "Could not find user");
      return apiSuccess(message: "User found!", data: user.toJson());
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> updateProfile(BuildContext context) async {
    try {
      AppUser? user = await getCurrentUser();
      if (user == null) return apiError(message: "Could not find user");
      return updateUser(user);
    } catch (e) {
      return apiServerError();
    }
  }
}
