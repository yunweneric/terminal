import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
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
              title: "Deposit Money",
              icon: AppIcons.deposit,
              color: Theme.of(context).hoverColor,
              onTap: () => context.push(AppRoutes.deposit),
              fontSize: 15.sp,
            ),
            HomeCard(
              title: "Withdraw Money",
              icon: AppIcons.withdraw,
              color: Theme.of(context).colorScheme.primary,
              onTap: () => withdrawalModal(context: context),
              fontSize: 15.sp,
            ),
          ],
        ),
        kh10Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            HomeCard(
              title: "All\nTransactions",
              icon: AppIcons.transactions,
              color: Theme.of(context).colorScheme.primary,
              onTap: () => context.push(AppRoutes.transactions),
              fontSize: 15.sp,
            ),
            HomeCard(
              title: "My\nAccounts",
              icon: AppIcons.card,
              color: Theme.of(context).hoverColor,
              fontSize: 15.sp,
              onTap: () => accountModal(context: context),
            ),
          ],
        ),
        kh20Spacer(),
      ],
    );
  }
}

withdrawalModal({required BuildContext context}) {
  return AppSheet.simpleModal(
    onClose: () {},
    isDismissible: true,
    context: context,
    height: 400.h,
    alignment: Alignment.center,
    padding: kAppPadding(),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Withdraw Money", style: Theme.of(context).textTheme.displayMedium),
          kh10Spacer(),
          Text(
            "How much do you want to withdraw from your account?",
            textAlign: TextAlign.center,
          ),
          kh20Spacer(),
          authInput(hint: "WJS98AHKP", context: context, label: "Account Number"),
          authInput(hint: "20,000", context: context, label: "Amount"),
          kh20Spacer(),
          submitButton(
            context: context,
            onPressed: () {
              context.pop();
            },
            text: "Proceed",
          ),
          kh10Spacer(),
        ],
      ),
    ),
  );
}

accountModal({required BuildContext context}) {
  return AppSheet.simpleModal(
    context: context,
    height: 300.h,
    alignment: Alignment.center,
    padding: kAppPadding(),
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          submitButton(
            context: context,
            onPressed: () {
              context.pop();
            },
            text: "Add Account",
          ),
          kh10Spacer(),
          submitButton(
            context: context,
            onPressed: () {
              context.pop();
            },
            text: "Remove Account",
          ),
          kh10Spacer(),
          submitButton(
            context: context,
            onPressed: () {
              context.pop();
            },
            text: "Account Holder",
          ),
          kh10Spacer(),
        ],
      ),
    ),
  );
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
              height: 150.h,
              decoration: BoxDecoration(color: color, borderRadius: radiusSm()),
              width: width ?? 150.w,
              child: Text(
                title,
                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: fontSize, color: kWhite),
              ),
            ),
          ),
          Positioned(
            child: SvgPicture.asset(icon, color: kWhite),
            top: 10,
            right: 10,
          )
        ],
      ),
    );
  }
}
