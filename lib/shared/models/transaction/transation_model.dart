import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';

class AppTransaction {
  final String name;
  final String id;
  final int amount;
  final String account_num;
  final String reference_id;
  final String transaction_id;
  final String status;
  DateTime createdAt;

  // AppTransaction();
  AppTransaction({
    required this.account_num,
    required this.reference_id,
    required this.transaction_id,
    required this.amount,
    required this.createdAt,
    required this.name,
    required this.status,
    required this.id,
  });

  static AppTransaction empty() {
    return AppTransaction(
      name: "",
      id: "",
      amount: 0,
      account_num: "",
      reference_id: "",
      transaction_id: "",
      createdAt: DateTime.now(),
      status: AppTransactionStatus.PENDING,
    );
  }

  static AppTransaction fake() {
    Faker faker = Faker();
    return AppTransaction(
      name: faker.person.name(),
      id: Uuid().v1(),
      amount: faker.randomGenerator.integer(32000),
      account_num: Uuid().v1(),
      reference_id: Uuid().v1(),
      transaction_id: Uuid().v1(),
      createdAt: DateTime.now(),
      status: faker.randomGenerator.element([AppTransactionStatus.PENDING, AppTransactionStatus.SUCCESS, AppTransactionStatus.FAILED]),
    );
  }
}