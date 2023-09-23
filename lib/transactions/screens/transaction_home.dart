import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/screens/data/model/transation.dart';
import 'package:xoecollect/transactions/screens/widgets/table_header.dart';
import 'package:xoecollect/transactions/screens/widgets/table_item.dart';

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
    List<Transaction> transactions = List.generate(
      20,
      (index) => Transaction(
        amount: faker.randomGenerator.integer(100000, min: 2000),
        createdAt: DateTime.now(),
        name: faker.person.firstName(),
        photoUrl: faker.image.image(),
      ),
    );
    return Scaffold(
      appBar: appBar(context: context, title: "Transactions", canPop: true),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: kPadding(10.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  tableHeaderItem(context: context, title: "#", isIndex: true),
                  tableHeaderItem(context: context, title: "Name", isName: true),
                  tableHeaderItem(context: context, title: "Amount"),
                  tableHeaderItem(context: context, title: "Date"),
                ],
              ),
            ),
            // Divider(thickness: 1.h),
            Expanded(
              // height: kHeight(context) / 1.3,
              child: ListView.builder(
                itemCount: transactions.length,
                // physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: kPadding(10.w, 20.h),
                    decoration: BoxDecoration(
                      border: BorderDirectional(
                        bottom: index.isOdd ? BorderSide(width: 1.h, color: Theme.of(context).highlightColor.withOpacity(0.2)) : BorderSide.none,
                      ),
                      color: index.isOdd ? Theme.of(context).primaryColor.withOpacity(0.1) : Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        tableItem(context: context, title: "${index + 1}", index: index, isIndex: true),
                        tableItem(context: context, title: transactions[index].name, index: index),
                        tableItem(context: context, title: Formaters.formatNumber(transactions[index].amount), index: index),
                        tableItem(
                          context: context,
                          title: transactions[index].amount > 0 ? Formaters.formatDateBase(transactions[index].createdAt, "d|MMM") : "0",
                          index: index,
                        ),
                      ],
                    ),
                  ).animate(delay: (100 * index).ms).slideY().fade();
                },
              ).animate(delay: 200.ms),
            ),
          ],
        )),
      ),
    );
  }
}
