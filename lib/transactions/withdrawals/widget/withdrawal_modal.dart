import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/modals.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/helpers.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/shared/theme/colors.dart';
import 'package:xoecollect/transactions/logic/home_deposit/home_deposit_cubit.dart';
import 'package:xoecollect/transactions/logic/transaction/transaction_cubit.dart';
import 'package:xoecollect/transactions/logic/withdraw/withdraw_cubit.dart';
import 'package:xoecollect/transactions/withdrawals/widget/enter_account_code.dart';

class WithDrawalModal {
  static showWithdrawalModal({required BuildContext context, bool loading = false}) {
    return AppSheet.simpleModal(
      onClose: () {},
      isDismissible: false,
      enableDrag: false,
      context: context,
      height: kHeight(context),
      alignment: Alignment.topCenter,
      child: BlocListener<TransactionCubit, TransactionState>(
        listener: (context, state) async {
          if (state is TransactionAddInitial) AppLoaders.showLoader(context: context);
          if (state is TransactionAddError) {
            AppLoaders.dismissEasyLoader();
            AppSheet.appErrorSheet(context: context, message: state.response.message);
          }
          if (state is TransactionAddSuccess) {
            AppLoaders.dismissEasyLoader();
            // context.pop();
            enterCodeModal(context, state.transaction);
            // successDepositModal(context: context, transaction: state.transaction, isDeposit: false);
          }
        },
        child: BlocProvider(
          create: (context) => WithdrawCubit(),
          child: BlocConsumer<WithdrawCubit, WithdrawState>(
            listener: (context, state) {
              // logI(state);
              if (state is HomeDepositAddedValue) {
                // logI(state.amount);
              }
            },
            builder: (context, state) {
              if (state is HomeDepositInitial) {
                // amountController.text = Formaters.formatCurrency(state.amount) + " FCFA";
              }
              if (state is HomeDepositAddedValue) {
                // amountController.text = Formaters.formatCurrency(state.amount) + " FCFA";
              }

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: kAppPadding(),
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
                          authInput(
                            hint: "98472",
                            context: context,
                            label: "Account No.",
                            keyboardType: TextInputType.number,
                            controller: context.watch<WithdrawCubit>().accountController,
                            maxLength: 5,
                            onChanged: (val) {
                              String value = val.trim();
                              String account = "${Helpers.base_account}${value}";
                              logI(account);
                              if (val.length > 4) {
                                BlocProvider.of<WithdrawCubit>(context).findUser(account, context);
                              }
                            },
                          ),
                          Container(
                            // color: Colors.teal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: authInput(
                                    hint: "20,000",
                                    controller: context.watch<WithdrawCubit>().amountController,
                                    context: context,
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) {
                                      BlocProvider.of<WithdrawCubit>(context).updateAmount(val);
                                    },
                                    label: "Amount",
                                  ),
                                ),
                                kwSpacer(10.w),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    kh20Spacer(),
                    Divider(),
                    Padding(
                      padding: kAppPadding(),
                      child: Column(
                        children: [
                          kh20Spacer(),
                          Text("Withdraw from", style: Theme.of(context).textTheme.displayMedium),
                          // loading
                          appLoaderBuilder(
                            loading: context.watch<WithdrawCubit>().loading,
                            error: context.watch<WithdrawCubit>().error,
                            hasData: context.watch<WithdrawCubit>().account != null,
                            loadingShimmer: Column(
                              children: [
                                kh20Spacer(),
                                kh20Spacer(),
                                AppLoaders.loadingWidget(context),
                                kh20Spacer(),
                                kh20Spacer(),
                              ],
                            ),
                            errorWidget: Container(
                              alignment: Alignment.center,
                              height: 100.h,
                              child: Text("Error while searching for account"),
                            ),
                            noDataWidget: Container(
                              alignment: Alignment.center,
                              height: 100.h,
                              child: Text(context.watch<WithdrawCubit>().message),
                            ),
                            child: Column(
                              children: [
                                kh20Spacer(),
                                ListTile(
                                  leading: Text('Account Name'),
                                  trailing: Text(
                                    context.watch<WithdrawCubit>().account?.name ?? "",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                ListTile(
                                  leading: Text('Account No'),
                                  trailing: Text(
                                    context.watch<WithdrawCubit>().account?.id ?? "",
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                kh20Spacer(),
                              ],
                            ),
                          ),
                          Divider(),
                          kh20Spacer(),
                          submitButton(
                            context: context,
                            onPressed: () {
                              // logI(context.read<WithdrawCubit>().account == null);
                              if (context.read<WithdrawCubit>().account == null) {
                                AppModal.showErrorAlert(
                                  context: context,
                                  title: "Transaction Status",
                                  desc: "Please enter a valid account",
                                );
                                return;
                              }
                              if (context.read<WithdrawCubit>().total_amount != 0) {
                                int code = Helpers.generateCode();
                                AppTransaction data = AppTransaction(
                                  account_num: context.read<WithdrawCubit>().account?.id ?? "",
                                  reference_id: Uuid().v1(),
                                  transaction_id: Uuid().v1(),
                                  amount: context.read<WithdrawCubit>().total_amount,
                                  createdAt: DateTime.now(),
                                  name: context.read<WithdrawCubit>().account?.name ?? "",
                                  status: AppTransactionStatus.PENDING,
                                  transaction_type: AppTransactionType.WITHDRAW,
                                  id: Uuid().v1(),
                                  code: code,
                                );

                                confirmWithdrawalModal(context, data);
                              }
                            },
                            color: context.read<WithdrawCubit>().account == null ? Theme.of(context).highlightColor : Theme.of(context).primaryColor,
                            text: "Withdraw",
                            textColor: context.read<WithdrawCubit>().account == null ? Theme.of(context).primaryColor : kWhite,
                          ),
                        ],
                      ),
                    ),
                    khSpacer(20.h),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static confirmWithdrawalModal(BuildContext context, AppTransaction transaction) {
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
            "Are you sure you want to withdraw ${transaction.amount} FCFA from ${transaction.name} with account ID ${transaction.account_num}",
            textAlign: TextAlign.center,
          ),
          kh20Spacer(),
          submitButton(
            context: context,
            onPressed: () {
              context.pop();
              BlocProvider.of<TransactionCubit>(context).addTransaction(context: context, data: transaction, isDeposit: false);
            },
            text: "Yes Proceed",
          ),
          kh10Spacer(),
          submitButton(
            color: Theme.of(context).cardColor,
            textColor: Theme.of(context).primaryColor,
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            context: context,
            onPressed: () => context.pop(),
            text: "No, Cancel",
          ),
        ],
      ),
    );
  }
}
