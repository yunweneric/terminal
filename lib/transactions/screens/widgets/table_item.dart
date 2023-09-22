import 'package:flutter/material.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

Widget tableItem({required String title, String? imageUrl, bool isIndex = false, required int index, required BuildContext context}) => Container(
      width: isIndex ? kWidth(context) / 15 : kWidth(context) / 3.7,
      // color: Colors.teal,
      margin: EdgeInsets.symmetric(horizontal: kWidth(context) * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
