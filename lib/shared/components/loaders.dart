import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppLoaders {
  static showLoader(context) {
    return SpinKitThreeBounce(
      color: Theme.of(context).primaryColor,
      size: 30.r,
    );
  }

  static showApiOverlay() {
    EasyLoading.show(
      dismissOnTap: false,
      maskType: EasyLoadingMaskType.black,
      indicator: Opacity(opacity: 0, child: Container(color: Colors.teal, width: 0, height: 0)),
    );
  }

  static hideApiOverlay() {
    EasyLoading.dismiss();
  }
}
