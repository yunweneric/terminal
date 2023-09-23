import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xoecollect/auth/data/logic/auth/auth_cubit.dart';
import 'package:xoecollect/auth/data/model/reset_pin_req_model.dart';
import 'package:xoecollect/auth/data/model/verification_routing.dart';
import 'package:xoecollect/config/app_config.dart';
import 'package:xoecollect/shared/models/auth/providers.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/models/users/user_roles.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/collection_service.dart';
import 'package:xoecollect/shared/utils/local_storage.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/users/data/services/user_service.dart';

class AuthService extends BaseService {
  FirebaseAuth auth = FirebaseAuth.instance;

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

  Future<AppBaseResponse> phoneVerification(BuildContext context, String smsCode, String phoneNumber, String verificationId) async {
    UserService userService = UserService();
    try {
      // * Sign in user if the token is valid

      PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await auth.signInWithCredential(credential);

      // * Get user collection depending of if we are in dev or prod
      var userCollection = await AppConfig.getCollection(AppCollections.USERS);

      // * Get currently signed in user
      User? user = await auth.currentUser;

      // * If is not authenticated, return null
      if (user != null) {
        String? token = await user.getIdToken();
        final query = await userCollection.where("phoneNumber", isEqualTo: phoneNumber).get();
        logI(["User found", phoneNumber, query.size]);
        if (query.size != 0) {
          Map<String, dynamic> data = query.docs.first.data();
          return apiSuccess(message: "User data", data: data);
        }
        // * If user  does not exists, create a new user object, dave to firebase and update his phone number on firebase auth!
        final myUser = AppUser(
          created_at: user.metadata.creationTime.toString(),
          uid: user.uid,
          username: user.displayName,
          phoneNumber: phoneNumber,
          photoUrl: user.photoURL,
          providerId: AuthProviders.PHONE,
          token: token ?? user.uid,
          nToken: [],
          role: AppRole(role: UserRoles.user, value: null),
        );

        await userService.addUser(myUser);
        return apiSuccess(message: "User data", data: myUser.toJson());
      }
      // * If user is not authenticated
      return apiError(message: "Could not authenticate user!. Please try again later!");
    } catch (e) {
      // showToastError("Internal server error: Please try again!!", e.toString());
      logError(e);
      FirebaseException err = e as FirebaseException;
      // logError(e.toString());
      // logError(err.message);
      // return apiServerError();
      return apiError(message: err.message ?? "Could not authenticate user!. Please try again later!");
    }
  }

  Future<AppBaseResponse> createPin(BuildContext context, String code) async {
    UserService userService = UserService();
    try {
      AppUser? user = await userService.getCurrentUser();
      if (user == null) return apiError(message: "Could not find user!");
      user.password = code;
      return userService.baseUpdate(data: user.toJson(), collectionRef: AppCollections.USERS);
    } catch (e) {
      return apiServerError();
    }
  }

  Future<AppBaseResponse> verifyPin(BuildContext context, String code) async {
    UserService userService = UserService();
    try {
      AppUser? user = await userService.getCurrentUser();
      if (user == null) return apiError(message: "Could not find user!");
      return apiSuccess(message: "User found!", data: user.toJson());
    } catch (e) {
      return apiServerError();
    }
  }
}
