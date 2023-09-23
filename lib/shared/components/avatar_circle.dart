import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/theme/colors.dart';

CircleAvatar avatarCircle({
  required BuildContext context,
  Color? circleColor,
  required double radius,
  String? image,
  String? name,
  localImage,
}) {
  return CircleAvatar(
    backgroundColor: circleColor ?? Theme.of(context).cardColor,
    radius: radius + 2.r,
    child: CircleAvatar(
      backgroundColor: circleColor ?? Theme.of(context).cardColor,
      radius: radius,
      child: ClipOval(
        child: localImage != null
            ? Container(child: localImage, width: 500.w, height: 500.h)
            : Container(
                child: CachedNetworkImage(
                  imageUrl: image ?? "https://randomuser.me/api/portraits/women/${Random().nextInt(100)}.jpg",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200.0,
                  errorWidget: ((context, url, error) => Center(child: Icon(Icons.replay_outlined))),
                  placeholder: (_, __) => Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: name == null ? CupertinoActivityIndicator(color: Theme.of(context).primaryColor) : Text(Formaters.getFirstLetter(name)),
                    ),
                  ),
                ),
              ),
      ),
    ),
  );
}

CircleAvatar avatarNameCircle({
  required BuildContext context,
  required double radius,
  required String name,
}) {
  return CircleAvatar(
    backgroundColor: Theme.of(context).primaryColor,
    radius: radius + 2.r,
    child: Text(Formaters.getFirstLetter(name), style: Theme.of(context).textTheme.displayLarge!.copyWith(color: kWhite)),
  );
}
