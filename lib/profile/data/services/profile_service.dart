import 'package:faker/faker.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/models/account/user_model.dart';
import 'package:xoecollect/shared/models/base/base_res_model.dart';
import 'package:xoecollect/shared/services/user_service.dart';

class ProfileService extends UserService {
  Future<AppBaseResponse> findProfileData(BuildContext context) async {
    Faker faker = Faker();
    await Future.delayed(1200.milliseconds);
    AppUser user = AppUser(
      uuid: Uuid().v1(),
      createdAt: DateTime.now(),
      email: faker.internet.email(),
      username: faker.person.name(),
      phone: faker.phoneNumber.us(),
      photoUrl: faker.image.image(),
      role: Role(createdAt: DateTime.now(), name: "agent", uuid: Uuid().v1(), description: ""),
    );

    return apiSuccess(message: "", data: user.toJson());
  }
}
