import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

Widget appLoaderBuilder({
  required bool loading,
  required bool error,
  required bool hasData,
  required Widget child,
  required Widget loadingShimmer,
  required Widget errorWidget,
  required Widget noDataWidget,
}) {
  return Builder(builder: (context) {
    if (loading && !error) {
      return loadingShimmer;
    }
    if (!loading && error) {
      return errorWidget;
    }
    if (!loading && !error && !hasData) {
      return noDataWidget;
    }
    if (!loading && !error && hasData) {
      return child;
    } else
      return FadeIn(child: child);
  });
}
