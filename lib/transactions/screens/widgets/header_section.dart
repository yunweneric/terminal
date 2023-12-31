import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/shared/components/header_amount.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class HeaderSection extends StatelessWidget {
  final AppTransaction transaction;
  const HeaderSection({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          khSpacer(kToolbarHeight),
          Padding(
            padding: kph(10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(onTap: () => context.pop(), child: Icon(Icons.arrow_back, color: kWhite)),
                Text(
                  "Transaction Details",
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: kWhite),
                ),
                Icon(Icons.more_vert, color: kWhite),
              ],
            ),
          ),
          kh10Spacer(),
          // CircleAvatar(
          //   radius: 35.r,
          //   backgroundColor: kWhite,
          //   child: Text(
          //     Formaters.formatDateBase(transaction.createdAt, "H:mm"),
          //     style: Theme.of(context).textTheme.displayMedium!.copyWith(color: Theme.of(context).primaryColor, fontSize: 18.sp),
          //   ),
          // ),

          headerAmount(title: "Available Balance", amount: transaction.amount, context: context),
          kh20Spacer(),
          // Divider(color: kWhite, endIndent: 50.w, indent: 50.w, thickness: 1.5.h),
          // Divider(color: kWhite.withOpacity(0.5)),
          // Text(
          //   transaction.name,
          //   style: Theme.of(context).textTheme.displayMedium!.copyWith(color: kWhite, fontWeight: FontWeight.w400),
          // ),
          // Text(
          //   transaction.account_num,
          //   style: Theme.of(context).textTheme.displaySmall!.copyWith(color: kWhite, fontWeight: FontWeight.w400),
          // ),
          // kh10Spacer(),
        ],
      ),
    );
  }
}
