import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/logic/cubit/transaction_cubit.dart';

TextEditingController controller = TextEditingController();
enterCodeModal(BuildContext context, AppTransaction transaction) {
  AppSheet.simpleModal(
    enableDrag: false,
    isDismissible: false,
    context: context,
    height: 300.h,
    alignment: Alignment.center,
    padding: kAppPadding(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Withdraw Money", style: Theme.of(context).textTheme.displayMedium),
        kh10Spacer(),
        Text(
          "Please enter the verification code that was sent to your phone by SMS",
          textAlign: TextAlign.center,
        ),
        authInput(
          hint: "3942",
          label: "Code",
          context: context,
          keyboardType: TextInputType.number,
          controller: controller,
        ),
        kh20Spacer(),
        submitButton(
          context: context,
          onPressed: () {
            // context.pop();
            BlocProvider.of<TransactionCubit>(context).reconcileTransaction(
              context: context,
              data: transaction,
              code: controller.text.trim(),
            );
          },
          text: "Yes Proceed",
        ),
        kh10Spacer(),
      ],
    ),
  );
}
