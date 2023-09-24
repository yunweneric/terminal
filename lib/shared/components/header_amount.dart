import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/theme/colors.dart';

headerAmount({required String title, required int amount, required BuildContext context, Color? amountColor, Color? textColor}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Column(
        children: [
          Container(
            child: Text(
              Formaters.formatCurrency(amount),
              style: Theme.of(context).textTheme.displayLarge!.copyWith(color: amountColor ?? kWhite, fontSize: 35.sp),
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: textColor ?? kWhite, fontWeight: FontWeight.w400),
          ),
        ],
      ),
      Positioned(
        top: 0,
        right: -30,
        child: Text(
          "FCFA",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: amountColor ?? kWhite),
        ),
      ),
    ],
  );
}
