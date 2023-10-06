import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/logic/transaction/transaction_cubit.dart';
import 'package:xoecollect/transactions/deposits/widgets/success_deposit_modal.dart';
import 'package:xoecollect/transactions/withdrawals/widget/enter_account_code.dart';

class HeaderBody extends StatelessWidget {
  final AppTransaction transaction;

  const HeaderBody({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {},
      child: Expanded(
        child: Container(
          padding: EdgeInsets.only(left: 20.w, right: 20.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                kh20Spacer(),
                Item(context, transaction.transaction_type == AppTransactionType.DEPOSIT ? "You Deposited" : "You've withdrawn", Formaters.formatCurrency(transaction.amount) + " Fcfa"),
                Item(context, transaction.transaction_type == AppTransactionType.DEPOSIT ? "To" : "From", transaction.name),
                Item(context, "Account No.", transaction.account_num),
                Item(context, "Status", transaction.status),
                Item(context, "Date", Formaters.formatDate(transaction.createdAt)),
                Item(context, "Transaction ID", transaction.transaction_id),
                Item(context, "Reference ID", transaction.reference_id),
                if (transaction.status == AppTransactionStatus.SUCCESS)
                  submitButton(
                    context: context,
                    onPressed: () {
                      successDepositModal(
                        context: context,
                        transaction: transaction,
                        isDeposit: transaction.transaction_type == AppTransactionType.DEPOSIT,
                      );
                    },
                    text: "View Receipt",
                  ),
                if (transaction.status == AppTransactionStatus.PENDING)
                  submitButton(
                    context: context,
                    onPressed: () {
                      enterCodeModal(context, transaction);
                    },
                    text: "Complete transaction",
                  ),
                kh20Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Item(BuildContext context, String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          kwSpacer(20.w),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
