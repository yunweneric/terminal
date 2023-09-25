import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:xoecollect/auth/widgets/app_pin.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/models/others/sheet_action_model.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

class AppSheet {
  static baseBottomSheet({required BuildContext context, bool? enableDrag, bool? isDismissible, required Widget child}) {
    return showBarModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      context: context,
      builder: (context) => child,
      // topControl: Container(),
      useRootNavigator: false,
      barrierColor: kDark.withOpacity(0.7),
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
          AppLoaders.showLoader(context: context),
          kh10Spacer(),
          Text(text, style: Theme.of(context).textTheme.displaySmall),
        ],
      ),
    );
  }

  static showPinSheet({required context, required onValidate}) {
    String entered_pin = "";
    return AppSheet.simpleModal(
      context: context,
      isDismissible: true,
      enableDrag: false,
      height: 500.h,
      padding: kPadding(30.w, 50.w),
      alignment: Alignment.topCenter,
      child: StatefulBuilder(builder: (context, setNewState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Enter your Pin", style: Theme.of(context).textTheme.displayLarge),
            kh20Spacer(),
            AppPin(
              length: 4,
              onChanged: (pin) {
                setNewState(() {
                  entered_pin = pin;
                });
              },
            ),
            kh20Spacer(),
            submitButton(
              width: 180.w,
              context: context,
              onPressed: () {
                if (entered_pin.length < 4) {
                  showToastError("Enter valid Pin");
                  return;
                }
                onValidate(entered_pin);
              },
              text: "Validate",
            )
          ],
        );
      }),
    );
  }

  static _appStateBaseSheet({
    required BuildContext context,
    required bool isError,
    required String message,
    List<Widget>? actions,
    bool? isDismissible,
    bool? enableDrag,
    VoidCallback? onClose,
  }) {
    return AppSheet.simpleModal(
      context: context,
      isDismissible: isDismissible ?? false,
      enableDrag: enableDrag ?? false,
      onClose: onClose,
      height: 500.h,
      padding: kAppPadding(),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(scale: 4, child: Lottie.asset(isError ? AnimationAsset.error : AnimationAsset.success, width: 150.h)),
          // kh20Spacer(),
          Text(
            message,
            textAlign: TextAlign.center,
          ),
          kh20Spacer(),
          if (actions != null) ...actions,
        ],
      ),
    );
  }

  static appErrorSheet({
    required BuildContext context,
    VoidCallback? okAction,
    VoidCallback? onCancel,
    VoidCallback? onClose,
    required String message,
    String? okText,
    String? cancelText,
    bool? isDismissible,
    bool? enableDrag,
    List<Widget>? actions,
  }) {
    AppSheet._appStateBaseSheet(
      context: context,
      message: message,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isError: true,
      actions: [
        kh20Spacer(),
        if (okAction != null)
          submitButton(
            context: context,
            onPressed: () {
              context.pop();
              okAction();
            },
            text: okText ?? "Try Again",
          ),
        if (onCancel != null) kh10Spacer(),
        if (onCancel != null)
          submitButton(
            color: Theme.of(context).cardColor,
            textColor: Theme.of(context).primaryColor,
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            context: context,
            onPressed: () async {
              context.pop();
              onCancel();
            },
            text: cancelText ?? "Cancel!",
          ),
      ],
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
    VoidCallback? onClose,
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
