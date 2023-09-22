import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xoecollect/profile/screens/widgets/profile_tile.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/shadows.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

AnimateList<Widget> profileScreenShimmer(BuildContext context) {
  return AnimateList(
    interval: 10.ms,
    effects: [ScaleEffect(), FadeEffect()],
    delay: 40.ms,
    children: [
      kh20Spacer(),
      Align(
        alignment: Alignment.center,
        child: Shimmer.fromColors(
          baseColor: Theme.of(context).highlightColor.withOpacity(0.5),
          highlightColor: Theme.of(context).primaryColorLight,
          child: CircleAvatar(radius: 60.r, backgroundColor: Theme.of(context).primaryColor),
        ),
      ),
      // kh20Spacer(),
      // Column(
      //   children: [
      //     Container(
      //       padding: kph(20.w),
      //       decoration: BoxDecoration(borderRadius: radiusL()),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           profileCounterShimmer(context: context),
      //           profileCounterShimmer(context: context),
      //           profileCounterShimmer(context: context),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),

      kh20Spacer(),
      Container(
        padding: kPadding(10.w, 10.h),
        margin: kAppPadding(),
        decoration: BoxDecoration(
          boxShadow: appShadow(context),
          color: Theme.of(context).cardColor,
          borderRadius: radiusSm(),
        ),
        child: Column(
          children: List.generate(5, (index) => profileInfoShimmer(context: context)),
        ),
      ),
      kh20Spacer(),
      Container(
        padding: kPadding(10.w, 5.h),
        margin: kAppPadding(),
        decoration: BoxDecoration(
          boxShadow: appShadow(context),
          color: Theme.of(context).cardColor,
          borderRadius: radiusSm(),
        ),
        child: profileInfoShimmer(
          context: context,
          scale: 0.7,
          showDivider: false,
        ),
      ),
    ],
  );
}
