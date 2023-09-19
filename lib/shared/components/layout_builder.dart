import 'package:flutter/material.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

Widget appLayout({required Widget mobileWidget, required Widget desktopWidget}) {
  return LayoutBuilder(
    builder: (context, constrain) {
      if (isMobile(constrain.maxWidth)) {
        return mobileWidget;
      } else if (isDesktop(constrain.maxWidth)) {
        return desktopWidget;
      } else
        return mobileWidget;
    },
  );
}
