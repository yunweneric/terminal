import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';
import 'package:xoecollect/transactions/logic/cubit/transaction_cubit.dart';
import 'package:xoecollect/transactions/screens/widgets/transaction_list.dart';

class TransactionHomeScreen extends StatefulWidget {
  const TransactionHomeScreen({super.key});

  @override
  State<TransactionHomeScreen> createState() => _TransactionHomeScreenState();
}

class _TransactionHomeScreenState extends State<TransactionHomeScreen> {
  String? filter;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, title: "Transaction History", canPop: true, centerTitle: true),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              kh20Spacer(),
              Padding(
                padding: kPadding(20.w, 0.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          chip(
                            context: context,
                            title: "All",
                            color: filter == null ? Theme.of(context).primaryColor : null,
                            currentFilter: null,
                          ),
                          kwSpacer(10.w),
                          chip(
                            context: context,
                            title: "Deposit",
                            color: filter == AppTransactionType.DEPOSIT ? Theme.of(context).primaryColor : null,
                            currentFilter: AppTransactionType.DEPOSIT,
                          ),
                          kwSpacer(10.w),
                          chip(
                            context: context,
                            title: "Withdrawal",
                            color: filter == AppTransactionType.WITHDRAW ? Theme.of(context).primaryColor : null,
                            currentFilter: AppTransactionType.WITHDRAW,
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.asset(AppIcons.calendar)
                  ],
                ),
              ),
              kh20Spacer(),
              TransactionList(height: kHeight(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget chip({
    required BuildContext context,
    required String title,
    Color? color,
    String? currentFilter,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() => filter = currentFilter);
        context.read<TransactionCubit>().filter(currentFilter);
      },
      child: Chip(
        backgroundColor: color ?? Theme.of(context).cardColor,
        side: BorderSide(color: Theme.of(context).highlightColor),
        padding: kPadding(5.w, 8.h),
        label: Text(title),
        labelStyle: Theme.of(context).textTheme.displaySmall!.copyWith(color: color == null ? null : kWhite),
      ),
    );
  }
}
