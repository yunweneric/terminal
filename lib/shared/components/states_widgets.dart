import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/shared/theme/colors.dart';

class AppStateWidget {
  static loadingWidget({required BuildContext context, double? height}) {
    return Container(
      height: height,
      child: Center(child: AppLoaders.loadingWidget(context)),
    );
  }

  static errorWidget({required String message, required Function onReload, required BuildContext context, double? height}) {
    return Container(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            kh10Spacer(),
            ActionChip(
              padding: kPadding(10.w, 10.h),
              onPressed: () => onReload(),
              label: Text("Reload", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: kWhite)),
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  static noData({required String title, required BuildContext context, double? height}) {
    return Container(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("No ${title} available"),
          ],
        ),
      ),
    );
  }
}
