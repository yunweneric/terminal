import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'package:xoecollect/shared/utils/index.dart';

class AppLoaders {
  static Widget loadingWidget(context) {
    return SpinKitFadingCircle(
      color: Theme.of(context).primaryColor,
      size: 50.0,
    );
  }

  static void easySuccess(context) {
    EasyLoading.show(
      dismissOnTap: true,
      status: ' ',
      maskType: EasyLoadingMaskType.custom,
      indicator: _successLoader(),
    );
    EasyLoading.dismiss();
  }

  static void dismissEasyLoader() {
    EasyLoading.dismiss();
  }

  static void easySuccessPop(context) {
    EasyLoading.show(
      dismissOnTap: true,
      status: ' ',
      maskType: EasyLoadingMaskType.custom,
      indicator: _successLoader(),
    );
    Future.delayed(Duration(seconds: 2), () {
      EasyLoading.dismiss();
      Navigator.pop(context);
    });
  }

  static SizedBox _successLoader() {
    return SizedBox(
      height: 200.h,
      child: Lottie.asset(AnimationAsset.success),
    );
  }

  static showLoader({bool? dismissOnTap, required BuildContext context}) {
    EasyLoading.show(
      dismissOnTap: dismissOnTap,
      maskType: EasyLoadingMaskType.custom,
      indicator: Container(
        height: 100,
        width: 100,
        child: SpinKitFadingCircle(
          color: Theme.of(context).primaryColor,
          size: 50.0,
        ),
      ),
    );
  }

  static Widget listShimmer(int length, context, bool canScroll) {
    return Shimmer.fromColors(
      highlightColor: Theme.of(context).cardColor,
      baseColor: Theme.of(context).highlightColor,
      enabled: true,
      child: ListView.builder(
        physics: canScroll ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        shrinkWrap: canScroll ? false : true,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.only(bottom: 20.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(50.r),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 8.h,
                      color: Theme.of(context).cardColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                    ),
                    Container(
                      width: double.infinity,
                      height: 8.h,
                      color: Theme.of(context).cardColor,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    Container(
                      width: 40.w,
                      height: 8.h,
                      color: Theme.of(context).cardColor,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        itemCount: length,
      ),
    );
  }
}
