import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class AppModal {
  static baseBottomSheet({required BuildContext context, required Widget child}) {
    return showBarModalBottomSheet(
      backgroundColor: Theme.of(context).cardColor,
      context: context,
      builder: (context) => child,
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
  }) {
    return baseBottomSheet(
      context: context,
      child: Container(
        child: child,
        alignment: alignment,
        height: height,
        padding: padding,
        margin: margin,
        decoration: decoration,
      ),
    );
  }
}
