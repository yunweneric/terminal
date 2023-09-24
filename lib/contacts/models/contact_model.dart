import 'package:faker/faker.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:uuid/uuid.dart';

class Account extends TaggedItem {
  final String name;
  final String id;
  DateTime createdAt;

  // Account();
  Account({
    required this.createdAt,
    required this.name,
    required this.id,
  });

  static Account empty() {
    return Account(
      name: "",
      id: "",
      createdAt: DateTime.now(),
    );
  }

  static Account fake() {
    Faker faker = Faker();
    return Account(
      name: faker.person.name(),
      id: Uuid().v1(),
      createdAt: DateTime.now(),
    );
  }

  @override
  String sortName() {
    return this.name;
  }
}
