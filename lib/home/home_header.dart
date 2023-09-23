import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class HeaderSection extends StatelessWidget {
  final AppUser? user;
  final Widget child;
  final AlignmentGeometry? alignment;
  const HeaderSection({
    super.key,
    required this.user,
    required this.child,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: alignment ?? Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.r), bottomRight: Radius.circular(30.r)),
          ),
          // height: 300.h,
          padding: kPadding(0, 30.h),
          width: kWidth(context),
          child: child,
        ),
        Container(
          padding: kph(20.w),
          margin: kpv(20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaction History", style: Theme.of(context).textTheme.displayMedium),
              Row(
                children: [
                  Text("View All"),
                  kwSpacer(5.w),
                  SvgPicture.asset(AppIcons.chevron_right),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
