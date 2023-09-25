import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/screens/widgets/trannsaction_card.dart';
import 'package:xoecollect/transactions/screens/widgets/transaction_list.dart';

class Transaction {
  final String name;
  final String? photoUrl;
  final int amount;
  final DateTime createdAt;

  Transaction({required this.amount, required this.createdAt, required this.name, this.photoUrl});
}

class TransactionHomeScreen extends StatefulWidget {
  const TransactionHomeScreen({super.key});

  @override
  State<TransactionHomeScreen> createState() => _TransactionHomeScreenState();
}

class _TransactionHomeScreenState extends State<TransactionHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Faker faker = Faker();
    List<AppTransaction> transactions = List.generate(20, (index) => AppTransaction.fake());
    return Scaffold(
      appBar: appBar(context: context, title: "Transaction History", canPop: true, centerTitle: true),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TransactionList(height: kHeight(context) / 1.2),
            ],
          ),
        ),
      ),
    );
  }
}
