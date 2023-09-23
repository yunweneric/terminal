import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/auth/widgets/app_pin.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class PinSheet extends StatefulWidget {
  final Function onValidate;
  const PinSheet({super.key, required this.onValidate});

  @override
  State<PinSheet> createState() => _PinSheetState();
}

class _PinSheetState extends State<PinSheet> {
  String entered_pin = "";
  @override
  Widget build(BuildContext context) {
    return AppSheet.simpleModal(
      context: context,
      isDismissible: true,
      enableDrag: false,
      height: 500.h,
      padding: kPadding(30.w, 50.w),
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Enter your Pin", style: Theme.of(context).textTheme.displayLarge),
          kh20Spacer(),
          AppPin(
            length: 4,
            onChanged: (pin) {
              setState(() {
                entered_pin = pin;
              });
            },
          ),
          kh20Spacer(),
          submitButton(
            width: 180.w,
            context: context,
            onPressed: () => widget.onValidate(entered_pin),
            text: "Validate",
          )
        ],
      ),
    );
  }
}
