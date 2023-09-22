import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/shadows.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

Widget profileInfo({
  required String title,
  required String value,
  required String icon,
  required BuildContext context,
  double scale = 1,
  bool showDivider = true,
  VoidCallback? onTap,
}) =>
    InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: kWidth(context),
            margin: kPadding(5.h, 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 25.h,
                      width: 25.h,
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.r)),
                      child: Transform.scale(
                        scale: scale,
                        child: SvgPicture.asset(icon, color: Theme.of(context).primaryColorLight),
                      ),
                    ),
                    kwSpacer(10.w),
                    Text(title),
                  ],
                ),
                Spacer(),
                Expanded(child: Text(value, softWrap: true, textAlign: TextAlign.end)),
              ],
            ),
          ),
          if (showDivider) Divider()
        ],
      ),
    );

Widget profileInfoShimmer({
  required BuildContext context,
  double scale = 1,
  bool showDivider = true,
}) =>
    Shimmer.fromColors(
      baseColor: Theme.of(context).highlightColor.withOpacity(0.5),
      highlightColor: Theme.of(context).primaryColorLight,
      child: Column(
        children: [
          Container(
            width: kWidth(context),
            margin: kPadding(5.h, 5.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 25.h,
                  width: 25.h,
                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.r)),
                  child: Transform.scale(
                    scale: scale,
                    child: SizedBox(),
                  ),
                ),
                kwSpacer(10.w),
                Container(width: 150.w, height: 3.h, color: Colors.red),
                Spacer(),
                Container(width: 30.w, height: 3.h, color: Colors.red),
              ],
            ),
          ),
          if (showDivider) Divider()
        ],
      ),
    );

Container profileCounter({required BuildContext context, required String title, required String count}) {
  return Container(
    padding: kPadding(0.w, 25.h),
    width: kWidth(context) / 3.6,
    decoration: BoxDecoration(
      color: title != "Points" ? Theme.of(context).cardColor.withOpacity(1) : Theme.of(context).primaryColor,
      boxShadow: appShadow(context),
      borderRadius: radiusSm(),
    ),
    child: Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: title == "Points" ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
        ),
        khSpacer(10.h),
        Text(
          count,
          style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 20.sp, color: title == "Points" ? Theme.of(context).primaryColorLight : Theme.of(context).primaryColor),
        ),
      ],
    ),
  );
}

Widget profileCounterShimmer({required BuildContext context}) {
  return Container(
    decoration: BoxDecoration(color: Theme.of(context).cardColor, boxShadow: appShadow(context), borderRadius: radiusSm()),
    child: Shimmer.fromColors(
      baseColor: Theme.of(context).highlightColor.withOpacity(0.5),
      highlightColor: Theme.of(context).primaryColorLight,
      child: Container(
        padding: kPadding(0.w, 25.h),
        width: kWidth(context) / 3.6,
        child: Column(
          children: [
            khSpacer(20.h),
            Container(width: 30.w, height: 2.h, color: Colors.red),
            khSpacer(10.h),
            Container(width: 30.w, height: 2.h, color: Colors.red),
            khSpacer(20.h),
          ],
        ),
      ),
    ),
  );
}
