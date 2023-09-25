import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/home/screens/widgets/deposit_modal.dart';
import 'package:xoecollect/routes/route_names.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class HeaderSection extends StatefulWidget {
  final AlignmentGeometry? alignment;
  const HeaderSection({
    super.key,
    this.alignment,
  });

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  bool view_amount = false;
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: widget.alignment ?? Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.r), bottomRight: Radius.circular(30.r)),
          ),
          // height: 300.h,
          padding: kPadding(0, 30.h),
          width: kWidth(context),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: kPadding(30.w, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    khSpacer(kToolbarHeight),
                    Expanded(
                      child: Text(
                        "Cash Collect",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: kWhite),
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset(AppIcons.bell),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            children: [
                              Container(
                                child: Text(
                                  view_amount ? Formaters.formatCurrency(22000) : "****",
                                  style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kWhite, fontSize: 35.sp),
                                ),
                              ),
                              Text(
                                "Available Balance",
                                style: Theme.of(context).textTheme.displaySmall!.copyWith(color: kWhite, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: -30,
                            child: Text(
                              "FCFA",
                              style: Theme.of(context).textTheme.bodySmall!.copyWith(color: kWhite),
                            ),
                          ),
                        ],
                      ),
                      kwSpacer(20.w),
                      Transform.scale(
                        scale: 1,
                        child: GestureDetector(
                          onTap: () {
                            context.push(AppRoutes.auth_pin_screen);
                            // AppSheet.showPinSheet(
                            //   context: context,
                            //   onValidate: (pin) {
                            //     logI(pin);
                            //     setState(() {
                            //       view_amount = !view_amount;
                            //     });
                            //     context.pop();
                            //   },
                            // );
                          },
                          child: SvgPicture.asset(AppIcons.visibility_off),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              kh20Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  headerChip(context: context, title: "Withdraw", onTap: () {}),
                  kwSpacer(10.w),
                  headerChip(
                    context: context,
                    title: "Deposit",
                    onTap: () {
                      depositMoney(context: context, loading: loading);
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          loading = false;
                        });
                      });
                    },
                    isDeposit: true,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          padding: kph(20.w),
          margin: kpv(20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaction History", style: Theme.of(context).textTheme.displayMedium),
              GestureDetector(
                onTap: () => context.push(AppRoutes.transactions),
                child: Row(
                  children: [
                    Text("View All"),
                    kwSpacer(5.w),
                    SvgPicture.asset(AppIcons.chevron_right),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget headerChip({required BuildContext context, bool? isDeposit, required String title, required VoidCallback onTap}) {
    return submitButton(
      padding: kPadding(0, 15.h),
      icon: CircleAvatar(
        backgroundColor: kWhite,
        radius: 12.r,
        child: Icon(Icons.add, size: 20.r),
      ),
      width: 150.w,
      context: context,
      onPressed: onTap,
      color: isDeposit == true ? Theme.of(context).hintColor : kDangerLight,
      text: title,
      textColor: kDark,
    );
  }
}
