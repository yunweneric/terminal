import 'package:flutter/material.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

Widget tableHeaderItem({required String title, bool isName = false, bool isIndex = false, required BuildContext context}) => Container(
      width: isIndex ? kWidth(context) / 15 : kWidth(context) / 3.7,
      // color: Colors.teal,
      margin: EdgeInsets.symmetric(horizontal: kWidth(context) * 0.008),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displaySmall,
      ),
    );
