import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xoecollect/shared/models/account/user_model.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class AppHome extends StatelessWidget {
  final AppUser? user;
  const AppHome({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeCard(
              title: "Home",
              icon: AppIcons.clock,
              color: Theme.of(context).hoverColor,
              onTap: () {},
              fontSize: 15.sp,
            ),
            HomeCard(
              title: "My\nProfile",
              icon: AppIcons.user_profile,
              color: Theme.of(context).colorScheme.primary,
              fontSize: 15.sp,
              onTap: () {},
            ),
          ],
        ),
        kh10Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeCard(
              title: "All\nTransactions",
              icon: AppIcons.scan,
              color: Theme.of(context).colorScheme.primary,
              onTap: () {},
              fontSize: 15.sp,
            ),
            HomeCard(
              title: "My\nAccounts",
              icon: AppIcons.lock_home,
              color: Theme.of(context).hoverColor,
              fontSize: 15.sp,
              onTap: () {},
            ),
          ],
        ),
        kh20Spacer(),
      ],
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final String icon;
  final double? fontSize;
  final double? width;
  final Color color;
  final VoidCallback onTap;
  const HomeCard({
    super.key,
    required this.title,
    required this.icon,
    required this.fontSize,
    this.width,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              padding: kPadding(10.w, 20.h),
              alignment: Alignment.bottomLeft,
              height: 120.h,
              decoration: BoxDecoration(color: color, borderRadius: radiusSm()),
              width: width ?? kWidth(context) / 2.35,
              child: Text(
                title,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: fontSize, color: kWhite),
              ),
            ),
          ),
          width == kWidth(context)
              ? Positioned(
                  child: SvgPicture.asset(icon, color: kWhite),
                  top: 0,
                  bottom: 0,
                  right: 5,
                )
              : Positioned(
                  child: SvgPicture.asset(icon, color: kWhite),
                  top: 10,
                  right: 5,
                )
        ],
      ),
    );
  }
}
