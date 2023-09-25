import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

Widget transactionCard(BuildContext context, AppTransaction transaction) {
  return GestureDetector(
    onTap: () {
      context.push(AppRoutes.transaction_details, extra: transaction);
    },
    child: Container(
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            radius: 25.r,
            child: Text(
              Formaters.formatDateBase(transaction.createdAt, "H:mm"),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kWhite),
            ),
          ),
          kwSpacer(10.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(constraints: BoxConstraints(maxWidth: 150.w), child: Text(transaction.name)),
                  Container(
                    constraints: BoxConstraints(maxWidth: 150.w),
                    child: Text(
                      transaction.account_num,
                      style: Theme.of(context).textTheme.bodySmall,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          kwSpacer(10.w),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Chip(
                backgroundColor: Theme.of(context).primaryColorLight,
                avatar: CircleAvatar(
                  backgroundColor: transaction.status == AppTransactionStatus.SUCCESS ? kSuccess : kDanger,
                  radius: 5.r,
                  child: Icon(transaction.status == AppTransactionStatus.SUCCESS ? Icons.check : Icons.close, size: 8.r, color: kWhite),
                ),
                padding: EdgeInsets.zero,
                labelPadding: EdgeInsets.zero,
                label: Text(Formaters.formatCurrency(transaction.amount) + " F", style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
