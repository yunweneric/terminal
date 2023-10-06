import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/transactions/logic/transaction/transaction_cubit.dart';
import 'package:xoecollect/transactions/deposits/widgets/success_deposit_modal.dart';
import 'package:xoecollect/transactions/logic/withdraw/withdraw_cubit.dart';

enterCodeModal(BuildContext context, AppTransaction transaction) {
  AppSheet.simpleModal(
    enableDrag: false,
    isDismissible: false,
    context: context,
    height: 500.h,
    alignment: Alignment.topCenter,
    padding: kAppPadding(),
    child: BlocListener<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionReconcileInitial) AppLoaders.showLoader(context: context);
        if (state is TransactionReconcileError) {
          AppLoaders.dismissEasyLoader();
          showToastError(state.response.message);
        }
        if (state is TransactionReconcileSuccess) {
          AppLoaders.dismissEasyLoader();
          context.pop();
          context.pop();
          successDepositModal(context: context, transaction: state.transaction, isDeposit: false);
        }
      },
      child: BlocProvider(
        create: (context) => WithdrawCubit(),
        child: BlocConsumer<WithdrawCubit, WithdrawState>(
          listener: (context, state) {},
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  kh20Spacer(),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).highlightColor,
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                  kh20Spacer(),
                  Text("Withdraw Money", style: Theme.of(context).textTheme.displayMedium),
                  kh10Spacer(),
                  Text(
                    "Please enter the verification code that was sent by SMS",
                    textAlign: TextAlign.center,
                  ),
                  authInput(
                    hint: "3942",
                    label: "Code",
                    context: context,
                    keyboardType: TextInputType.number,
                    controller: context.read<WithdrawCubit>().codeController,
                  ),
                  kh20Spacer(),
                  submitButton(
                    context: context,
                    onPressed: () {
                      // context.pop();
                      if (context.read<WithdrawCubit>().codeController.text.trim().length < 0) {
                        showToastError("please enter a valid code");
                        return;
                      }
                      BlocProvider.of<TransactionCubit>(context).reconcileTransaction(
                        context: context,
                        data: transaction,
                        code: context.read<WithdrawCubit>().codeController.text.trim(),
                      );
                    },
                    text: "Yes Proceed",
                  ),
                  kh20Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
