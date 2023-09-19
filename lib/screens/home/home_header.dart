import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/models/account/user_model.dart';
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
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          alignment: alignment ?? Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.r), bottomRight: Radius.circular(30.r)),
          ),
          height: 300.h,
          width: kWidth(context),
          child: child,
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 20,
        //   child: Image.asset(ImageAssets.splash_curve, scale: 1.8, fit: BoxFit.cover),
        // )
      ],
    );
  }
}
