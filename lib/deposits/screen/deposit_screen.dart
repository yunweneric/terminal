import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/screens/widgets/table_header.dart';
import 'package:xoecollect/transactions/screens/widgets/table_item.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  @override
  Widget build(BuildContext context) {
    Faker faker = Faker();
    List<AppTransaction> transactions = List.generate(
      20,
      (index) => AppTransaction(
        amount: faker.randomGenerator.integer(100000, min: 2000),
        createdAt: DateTime.now(),
        name: faker.person.firstName(),
        id: faker.jwt.secret,
      ),
    );
    return Scaffold(
      appBar: appBar(context: context, title: "Deposits", canPop: true),
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Padding(
              padding: kPadding(10.w, 8.h),
              child: Align(
                alignment: Alignment.topRight,
                child: submitButton(
                  width: 100.w,
                  context: context,
                  onPressed: () => addDepositModal(context),
                  text: "Add Deposit",
                ),
              ),
            ),
            Padding(
              padding: kPadding(10.w, 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  addDepositModal(context) {
    return AppSheet.simpleModal(
      context: context,
      height: 400.h,
      alignment: Alignment.center,
      padding: kAppPadding(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Deposit Money", style: Theme.of(context).textTheme.displayMedium),
            kh10Spacer(),
            authInput(
              label: "Account Number",
              hint: "1298DKA9",
              context: context,
              keyboardType: TextInputType.text,
            ),
            authInput(
              label: "Amount",
              keyboardType: TextInputType.number,
              hint: "20,000",
              context: context,
            ),
            kh20Spacer(),
            submitButton(
              context: context,
              onPressed: () {
                context.pop();
              },
              text: "Proceed",
            ),
            kh10Spacer(),
            submitButton(
              color: Theme.of(context).cardColor,
              textColor: Theme.of(context).primaryColor,
              borderSide: BorderSide(color: Theme.of(context).primaryColor),
              context: context,
              onPressed: () => context.pop(),
              text: "Cancel",
            ),
          ],
        ),
      ),
    );
  }
}
