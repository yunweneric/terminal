import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/helpers/helpers.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';

class AppTransaction {
  final String name;
  final String id;
  final String transaction_type;
  final int amount;
  final int? code;
  final String account_num;
  final String reference_id;
  final String transaction_id;
  String status;
  DateTime createdAt;

  // AppTransaction();
  AppTransaction({
    required this.account_num,
    required this.reference_id,
    required this.transaction_id,
    required this.amount,
    required this.createdAt,
    required this.transaction_type,
    this.code,
    required this.name,
    required this.status,
    required this.id,
  });

  static AppTransaction empty() {
    return AppTransaction(
      name: "",
      id: "",
      amount: 0,
      code: 2003,
      account_num: "",
      reference_id: "",
      transaction_id: "",
      createdAt: DateTime.now(),
      status: AppTransactionStatus.PENDING,
      transaction_type: AppTransactionType.DEPOSIT,
    );
  }

  static AppTransaction fake() {
    Faker faker = Faker();
    return AppTransaction(
      name: faker.person.name(),
      id: Uuid().v1(),
      amount: faker.randomGenerator.integer(32000),
      account_num: Helpers.base_account.toString() + faker.randomGenerator.integer(99999, min: 10000).toString(),
      code: faker.randomGenerator.integer(9999, min: 1000),
      reference_id: Uuid().v1(),
      transaction_id: Uuid().v1(),
      createdAt: DateTime.now(),
      status: faker.randomGenerator.element([AppTransactionStatus.PENDING, AppTransactionStatus.SUCCESS, AppTransactionStatus.FAILED]),
      transaction_type: faker.randomGenerator.element([AppTransactionType.DEPOSIT, AppTransactionType.WITHDRAW]),
    );
  }

  factory AppTransaction.fromJson(Map<String, dynamic> json) {
    DateTime date = Formaters.timeStampToDate(json["createdAt"]);
    return AppTransaction(
      name: json["name"],
      id: json["id"],
      account_num: json["account_num"],
      amount: json["amount"],
      transaction_id: json["transaction_id"],
      reference_id: json["reference_id"],
      code: json["code"],
      createdAt: date,
      status: json["status"],
      transaction_type: json["transaction_type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "account_num": account_num,
        "transaction_id": transaction_id,
        "amount": amount,
        "reference_id": reference_id,
        "createdAt": createdAt,
        "code": code,
        "transaction_type": transaction_type,
        "status": status,
      };
}
