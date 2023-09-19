import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xoecollect/models/others/sheet_action_model.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/helpers.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class AppSheet {
  static baseBottomSheet({required BuildContext context, bool? enableDrag, bool? isDismissible, required Widget child}) {
    return showBarModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      context: context,
      builder: (context) => child,
      useRootNavigator: false,
      isDismissible: isDismissible ?? true,
      enableDrag: enableDrag ?? true,
    );
  }

  static loadingSheet(BuildContext context, String text) {
    return AppSheet.simpleModal(
      context: context,
      isDismissible: false,
      enableDrag: false,
      height: 300.h,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoaders.showLoader(context),
          kh10Spacer(),
          Text(text, style: Theme.of(context).textTheme.displaySmall),
        ],
      ),
    );
  }

  static errorSheet({required BuildContext context, required String message, List<Widget>? actions, bool? isDismissible, bool? enableDrag}) {
    return AppSheet.simpleModal(
      context: context,
      isDismissible: isDismissible ?? false,
      enableDrag: enableDrag ?? false,
      height: 400.h,
      padding: kAppPadding(),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(AnimationAsset.error, width: 150.h, height: 150.h),
          Text(message, textAlign: TextAlign.center),
          kh20Spacer(),
          if (actions != null) ...actions,
        ],
      ),
    );
  }

  static simpleModal({
    required BuildContext context,
    required double height,
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Decoration? decoration,
    AlignmentGeometry? alignment,
    bool? isDismissible,
    bool? enableDrag,
  }) {
    return baseBottomSheet(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      child: Container(
        child: child,
        alignment: alignment ?? Alignment.center,
        height: height,
        padding: padding,
        margin: margin,
        // margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        decoration: decoration,
      ),
    );
  }

  static void contactDriverSheet({
    required BuildContext context,
    String? phone,
    required String message,
    required String title,
    required String description,
  }) {
    List<SheetAction> actions = [
      SheetAction(
        title: "WhatsApp",
        icon: AppIcons.whatsapp,
        onTap: () => Helpers.contactWhatsApp(context: context, message: message, phone: phone),
      ),
      SheetAction(
        title: "Phone",
        icon: AppIcons.phone,
        onTap: () => Helpers.contactPhone(
          context: context,
          phone: phone,
        ),
      ),
    ];

    return AppSheet.simpleModal(
      context: context,
      height: 400.h,
      padding: kPadding(20.w, 30.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            kh20Spacer(),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            kh20Spacer(),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: actions.length,
              padding: kPadding(20.w, 30.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20.h,
                crossAxisSpacing: 20.h,
              ),
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () => actions[index].onTap(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: radiusM(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(actions[index].icon, color: kWhite),
                        khSpacer(5.h),
                        Text(actions[index].title, style: TextStyle(color: kWhite)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  static void crudSheet({
    required BuildContext context,
    required List<SheetAction> items,
    required Function onDelete,
    required Function onEdit,
    required Function onView,
  }) {
    List<SheetAction> actions = [
      SheetAction(title: "Delete", icon: AppIcons.trash, onTap: onDelete),
      SheetAction(title: "Edit", icon: AppIcons.edit, onTap: onEdit),
      SheetAction(title: "View", icon: AppIcons.view, onTap: onView),
      ...items,
    ];

    return AppSheet.simpleModal(
      context: context,
      height: 350.h,
      padding: EdgeInsets.symmetric(horizontal: 20.w) + EdgeInsets.only(top: 20.h),
      alignment: Alignment.center,
      child: GridView.builder(
        itemCount: actions.length,
        padding: kPadding(20.w, 30.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.h,
        ),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () => actions[index].onTap(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: radiusM(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(actions[index].icon, color: kWhite),
                  khSpacer(5.h),
                  Text(actions[index].title, style: TextStyle(color: kWhite)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static void actionSheet({
    required BuildContext context,
    required double height,
    required List<SheetAction> actions,
  }) {
    return AppSheet.simpleModal(
      context: context,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 20.w) + EdgeInsets.only(top: 20.h),
      alignment: Alignment.center,
      child: GridView.builder(
        itemCount: actions.length,
        padding: kPadding(20.w, 30.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.h,
        ),
        itemBuilder: ((context, index) {
          return GestureDetector(
            onTap: () => actions[index].onTap(),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: radiusM(),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(actions[index].icon, color: kWhite),
                  khSpacer(5.h),
                  Text(actions[index].title, style: TextStyle(color: kWhite)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  static listItem(BuildContext context, String icon, String title) {
    return ListTile(
      leading: Container(
        height: 30.h,
        width: 30.h,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: radiusM()),
        child: Transform.scale(scale: 0.6, child: SvgPicture.asset(icon, color: kWhite)),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
