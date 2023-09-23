import 'package:faker/faker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';

class ProfileService extends BaseService {
  Future<AppBaseResponse> findProfileData(BuildContext context) async {
    Faker faker = Faker();
    await Future.delayed(1200.milliseconds);
    AppUser user = AppUser(
      uid: Uuid().v1(),
      created_at: DateTime.now().toIso8601String(),
      email: faker.internet.email(),
      username: faker.person.name(),
      phoneNumber: faker.phoneNumber.us(),
      photoUrl: faker.image.image(),
      role: AppRole(role: "agent", value: Uuid().v1()),
      providerId: 'phone',
      token: '',
      nToken: [],
    );

    return apiSuccess(message: "", data: user.toJson());
  }
}
