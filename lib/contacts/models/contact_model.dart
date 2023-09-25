import 'package:faker/faker.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/helpers/helpers.dart';

class Account extends TaggedItem {
  final String name;
  final String id;
  DateTime createdAt;

  Account({
    required this.createdAt,
    required this.name,
    required this.id,
  });

  factory Account.empty() {
    return Account(
      name: "",
      id: Helpers.base_account + "0",
      createdAt: DateTime.now(),
    );
  }

  factory Account.fake(Faker? faker) {
    if (faker == null) {
      faker = Faker();
    }
    return Account(
      name: faker.person.name(),
      id: Helpers.base_account.toString() + faker.randomGenerator.integer(99999, min: 1000).toString(),
      createdAt: DateTime.now(),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json) {
    DateTime date = Formaters.timeStampToDate(json["createdAt"]);
    return Account(
      name: json["name"],
      id: json["id"],
      createdAt: date,
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "createdAt": createdAt,
      };

  @override
  String sortName() {
    return this.name;
  }
}
