import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:ez_trip/shared/components/buttons.dart';
import 'package:ez_trip/shared/components/radius.dart';
import 'package:ez_trip/shared/utils/index.dart';
import 'package:ez_trip/shared/utils/sizing.dart';

baseAlert({
  required BuildContext context,
  Widget? title,
  Widget? content,
  EdgeInsets? insetPadding,
  EdgeInsets? titlePadding,
  EdgeInsets? actionsPadding,
  List<Widget>? actions,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => Container(),
    transitionBuilder: (context, a1, a2, child) {
      var curve = Curves.easeInOutCirc.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: AnimatedOpacity(
          opacity: a1.value,
          duration: Duration(milliseconds: 200),
          child: AlertDialog(
            backgroundColor: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            title: title,
            content: content,
            actionsAlignment: MainAxisAlignment.center,
            insetPadding: insetPadding ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
            titlePadding: titlePadding ?? EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w),
            actionsPadding: actionsPadding ?? EdgeInsets.only(bottom: 40.h),
            actions: actions,
          ),
        ),
      );
    },
  );
}

showAlertInfo({
  required BuildContext context,
  required String title,
  required String desc,
  required Color color,
  bool showbuttons = true,
  required Function() onConfirmed,
}) {
  return showGeneralDialog(
    context: context,
    transitionDuration: Duration(milliseconds: 400),
    transitionBuilder: (context, a1, a2, child) {
      Tween<Offset> tween;
      tween = Tween(begin: Offset(0, -1), end: Offset.zero);
      return SlideTransition(
        position: tween.animate(CurvedAnimation(parent: a1, curve: Curves.easeInOutCirc)),
        child: child,
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Container(
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          title: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: kwidth(context),
                child: Column(
                  children: [
                    khSpacer(10),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displayMedium!.copyWith(color: color, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                right: 0,
                child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
              )
            ],
          ),
          content: Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 14.sp),
          ),
          actionsAlignment: MainAxisAlignment.center,
          insetPadding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 30.w),
          titlePadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w) + EdgeInsets.only(top: 30.h),
          actionsPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
          actions: [
            if (showbuttons)
              submitButton(
                animate: false,
                width: 120.w,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                context: context,
                onPressed: () => Navigator.pop(context),
                text: "Torna al modulo",
                textColor: Theme.of(context).primaryColor,
                color: Colors.transparent,
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            if (showbuttons) SizedBox(width: 20.w),
            if (showbuttons)
              submitButton(
                animate: false,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                width: 120.w,
                context: context,
                onPressed: onConfirmed,
                text: "Conferma",
                color: color,
              ),
          ],
        ),
      );
    },
  );
}

showAlertInfoNoAction({
  required BuildContext context,
  required String title,
  required String desc,
  required Color color,
}) {
  return showGeneralDialog(
    context: context,
    transitionBuilder: (context, a1, a2, child) {
      var curve = Curves.easeInOutCirc.transform(a1.value);
      return Transform.scale(
        scale: curve,
        child: AnimatedOpacity(
          opacity: a1.value,
          duration: Duration(milliseconds: 200),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            title: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: kwidth(context),
                  child: Column(
                    children: [
                      khSpacer(10),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: color, fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -10,
                  right: 0,
                  child: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.close)),
                )
              ],
            ),
            content: Text(
              desc,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 14.sp),
            ),
            actionsAlignment: MainAxisAlignment.center,
            contentPadding: EdgeInsets.only(bottom: 50.h),
            insetPadding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 30.w),
            titlePadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 30.w) + EdgeInsets.only(top: 30.h),
            actionsPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 0.w),
          ),
        ),
      );
    },
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
      return Container();
    },
  );
}

showAlertSuccess({
  required BuildContext context,
  required String title,
  required String desc,
  required Function() onConfirmed,
  String? btnText,
  Color? color,
}) {
  return baseAlert(
    context: context,
    content: Text(
      desc,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 14.sp),
    ),
    actions: [
      submitButton(
        animate: false,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        width: 120.w,
        context: context,
        onPressed: onConfirmed,
        text: btnText ?? "Ok",
        color: Theme.of(context).primaryColor,
      ),
    ],
  );
}

showQuizAlert({
  required BuildContext context,
  required String title,
  required String desc,
  required Function() onConfirmed,
  required bool isCorrect,
}) {
  return baseAlert(
    context: context,
    title: Container(
      height: kheight(context) / 3,
      width: kwidth(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: isCorrect ? 2 : 1.2,
            child: Lottie.asset(isCorrect ? AnimationAsset.success : AnimationAsset.error, height: isCorrect ? 100.h : 80.h),
          ),
          khSpacer(50.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 18.sp),
          ),
          khSpacer(5.h),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14.sp),
          ),
          khSpacer(20.h),
          Divider(endIndent: 20.w, indent: 20.w),
        ],
      ),
    ),
    actions: [
      submitButton(
        animate: false,
        width: 120.w,
        borderRadius: radiusSm(),
        context: context,
        onPressed: onConfirmed,
        text: "Next",
        color: Theme.of(context).primaryColor,
      ),
    ],
  );
}

showQuizResults({required BuildContext context, required int score, required int total, required Function() onConfirmed, required bool hasPassed}) {
  return baseAlert(
    context: context,
    title: Container(
      height: kheight(context) / 2.5,
      width: kwidth(context),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: hasPassed ? 2 : 1.5,
            child: Lottie.asset(hasPassed ? AnimationAsset.success : AnimationAsset.error, height: hasPassed ? 100.h : 80.h),
          ),
          khSpacer(50.h),
          RichText(
            text: TextSpan(
              text: "",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 40.sp, fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(text: score.toString()),
                TextSpan(text: '/$total'),
              ],
            ),
          ),
          khSpacer(20.h),
          Text(
            hasPassed ? "Congrats on passing the quiz! Keep up the good work!" : "Don't give up! Identify areas to improve. Keep trying!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 14.sp),
          ),
          khSpacer(20.h),
          Divider(endIndent: 20.w, indent: 20.w),
        ],
      ),
    ),
    actions: [
      submitButton(
        animate: false,
        width: 120.w,
        borderRadius: radiusSm(),
        context: context,
        onPressed: onConfirmed,
        text: "Complete",
        color: Theme.of(context).primaryColor,
      ),
    ],
  );
}

showExitAlert({required BuildContext context, required VoidCallback onExit, required VoidCallback onContinue}) {
  return baseAlert(
    context: context,
    title: Container(
      height: kheight(context) / 2.5,
      width: kwidth(context),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Transform.scale(
            scale: 1.5,
            child: Lottie.asset(AnimationAsset.success, height: 100.h),
          ),
          khSpacer(50.h),
          Text(
            "Are you sure you want to quit the quiz?",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 18.sp),
          ),
          khSpacer(20.h),
          Text(
            "You will lost all your current score and data!",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.normal, fontSize: 12.sp),
          ),
          khSpacer(10.h),
          Divider(endIndent: 20.w, indent: 20.w),
        ],
      ),
    ),
    actionsPadding: EdgeInsets.symmetric(horizontal: 30.w) + EdgeInsets.only(bottom: 30.h),
    actions: [
      submitButton(
        animate: false,
        // width: 180.w,
        borderRadius: radiusSm(),
        context: context,
        onPressed: onExit,
        text: "Yes Quit!",
        color: Theme.of(context).primaryColor,
      ),
      khSpacer(10.h),
      submitButton(
        animate: false,
        // width: 180.w,
        borderRadius: radiusSm(),
        context: context,
        onPressed: onContinue,
        text: "No",
        color: Theme.of(context).primaryColor,
      ),
    ],
  );
}
