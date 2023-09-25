import 'package:firebase_auth/firebase_auth.dart';
import 'package:xoecollect/config/app_config.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/collection_service.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';

class UserService extends BaseService {
  Future<AppBaseResponse> addUser(AppUser user) async {
    try {
      var user_collection = await AppConfig.getCollection(AppCollections.USERS);
      await user_collection.doc(user.uid).set(user.toJson());
      return apiSuccess(message: "User added successfully!", data: user.toJson());
    } catch (e) {
      logError(e);
      return apiServerError();
    }
  }

  Future<AppBaseResponse> updateUser(AppUser user) async {
    try {
      var user_collection = await AppConfig.getCollection(AppCollections.USERS);
      await user_collection.doc(user.uid).update(user.toJson());
      return apiSuccess(message: "User updated successfully!", data: user.toJson());
    } catch (e) {
      logError(e);
      return apiServerError();
    }
  }

  Future<AppBaseResponse> getUserById(String id) async {
    try {
      var user_collection = await AppConfig.getCollection(AppCollections.USERS);
      final query = await user_collection.where("uid", isEqualTo: id).get();
      if (query.size != 0) {
        Map<String, dynamic> data = query.docs.first.data();
        return apiSuccess(message: "User added successfully!", data: data);
      } else {
        return apiError(message: "Could not find user of od ${id}");
      }
    } catch (e) {
      logError(e);
      return apiServerError();
    }
  }

  Future<AppUser?> getCurrentUser() async {
    try {
      String? userId = await FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return null;
      var user_collection = await AppConfig.getCollection(AppCollections.USERS);
      final query = await user_collection.where("uid", isEqualTo: userId).get();
      if (query.size != 0) {
        Map<String, dynamic> data = query.docs.first.data();
        return AppUser.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      logError(e);
      return null;
    }
  }
}
