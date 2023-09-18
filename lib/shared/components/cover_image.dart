import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ez_trip/shared/utils/index.dart';
import 'package:ez_trip/shared/utils/sizing.dart';
import 'package:ez_trip/theme/colors.dart';

Widget coverImage({
  required BuildContext context,
  String? url,
  required double height,
  Alignment? alignment,
  double? borderRadius,
  bool hasOverLay = false,
  Widget? overLayWidget,
  AlignmentGeometry? stackAlignment,
}) {
  return Stack(
    alignment: stackAlignment ?? Alignment.center,
    children: [
      ClipRRect(
        borderRadius: borderRadius != null ? BorderRadius.circular(borderRadius) : BorderRadius.circular(0),
        child: CachedNetworkImage(
          imageUrl: url == null || url == "" ? ImageAssets.cover_error : url,
          width: kwidth(context),
          height: height,
          alignment: alignment ?? Alignment.center,
          progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer.fromColors(
            baseColor: Theme.of(context).highlightColor,
            highlightColor: Theme.of(context).cardColor,
            child: Container(
              width: kwidth(context),
              height: height,
              color: Theme.of(context).cardColor,
              child: Center(
                child: Text(downloadProgress.progress == null ? "0%" : (downloadProgress.progress! * 100).toStringAsFixed(2)),
              ),
            ).animate().fadeIn(),
          ),
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => Container(
            width: kwidth(context),
            height: height,
            child: Icon(Icons.error),
            decoration: BoxDecoration(color: Theme.of(context).highlightColor),
          ),
        ),
      ),
      if (hasOverLay)
        Positioned(
          child: Container(
            height: height,
            decoration: BoxDecoration(color: kDark.withOpacity(0.7)),
          ),
        ),
      if (hasOverLay) overLayWidget!
    ],
  );
}
