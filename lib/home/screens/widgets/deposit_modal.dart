import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_plus_keyboard/pin_plus_keyboard.dart';
import 'package:uuid/uuid.dart';
import 'package:xoecollect/home/logic/home_deposit/home_deposit_cubit.dart';
import 'package:xoecollect/home/screens/widgets/success_deposit_modal.dart';
import 'package:xoecollect/routes/index.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/modals.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/helpers/helpers.dart';
import 'package:xoecollect/shared/models/transaction/transaction_status.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/services/base_service.dart';
import 'package:xoecollect/shared/services/sms_service.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';
import 'package:xoecollect/transactions/logic/cubit/transaction_cubit.dart';

depositMoney({required BuildContext context, bool loading = false}) {
  List<int> amounts = [25, 50, 100, 200, 500, 1000, 2000, 2500, 3000, 5000, 10000];

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
          context.pop();
          successDepositModal(context: context, transaction: state.transaction);
        }
      },
      child: BlocProvider(
        create: (context) => HomeDepositCubit(),
        child: BlocConsumer<HomeDepositCubit, HomeDepositState>(
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

            if (state is HomeFindAccountInitial) {}
            if (state is HomeFindAccountInitial) {}

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
                          controller: context.watch<HomeDepositCubit>().accountController,
                          maxLength: 5,
                          onChanged: (val) {
                            String value = val.trim();
                            String account = "${Helpers.base_account}${value}";
                            logI(account);
                            if (val.length > 4) {
                              BlocProvider.of<HomeDepositCubit>(context).findUser(account, context);
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
                                  readOnly: true,
                                  // contentPadding: kPadding(10.w, 25.h),
                                  controller: context.watch<HomeDepositCubit>().amountController,
                                  context: context,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    BlocProvider.of<HomeDepositCubit>(context).updateSum(val);
                                  },
                                  label: "Amount",
                                ),
                              ),
                              kwSpacer(10.w),
                              Column(
                                children: [
                                  IconInputButton(
                                    icon: Icons.add,
                                    color: context.watch<HomeDepositCubit>().isAdditionOperator ? kSuccess : Theme.of(context).highlightColor,
                                    onTap: () => BlocProvider.of<HomeDepositCubit>(context).addOperator(isAddition: true),
                                  ),
                                  khSpacer(2.h),
                                  IconInputButton(
                                    icon: Icons.remove,
                                    color: !context.watch<HomeDepositCubit>().isAdditionOperator ? kSuccess : Theme.of(context).highlightColor,
                                    onTap: () => BlocProvider.of<HomeDepositCubit>(context).addOperator(isAddition: false),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  kh20Spacer(),
                  Container(
                    height: 30.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: amounts.length,
                      itemBuilder: ((context, index) {
                        return Row(
                          children: [
                            if (index == 0) kwSpacer(20.w),
                            Container(
                              margin: EdgeInsets.only(right: 20.w),
                              child: ActionChip(
                                padding: kPadding(10.w, 0.h),
                                backgroundColor: context.watch<HomeDepositCubit>().add_factor == amounts[index] ? Theme.of(context).primaryColor : null,
                                onPressed: () => BlocProvider.of<HomeDepositCubit>(context).addValue(amounts[index]),
                                label: Text(
                                  Formaters.formatCurrency(amounts[index]),
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: context.watch<HomeDepositCubit>().add_factor == amounts[index] ? kWhite : kDark),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  kh20Spacer(),
                  Divider(),
                  Padding(
                    padding: kAppPadding(),
                    child: Column(
                      children: [
                        kh20Spacer(),
                        Text("Deposit to", style: Theme.of(context).textTheme.displayMedium),
                        // loading
                        appLoaderBuilder(
                          loading: context.watch<HomeDepositCubit>().loading,
                          error: context.watch<HomeDepositCubit>().error,
                          hasData: context.watch<HomeDepositCubit>().account != null,
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
                            child: Text(context.watch<HomeDepositCubit>().message),
                          ),
                          child: Column(
                            children: [
                              kh20Spacer(),
                              ListTile(
                                leading: Text('Account Name'),
                                trailing: Text(
                                  context.watch<HomeDepositCubit>().account?.name ?? "",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              ListTile(
                                leading: Text('Account No'),
                                trailing: Text(
                                  context.watch<HomeDepositCubit>().account?.id ?? "",
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
                            // logI(context.read<HomeDepositCubit>().account == null);
                            if (context.read<HomeDepositCubit>().account == null) {
                              AppModal.showErrorAlert(
                                context: context,
                                title: "Transaction Status",
                                desc: "Please enter a valid account",
                              );
                              return;
                            }
                            if (context.read<HomeDepositCubit>().total_amount != 0) {
                              AppTransaction data = AppTransaction(
                                account_num: context.read<HomeDepositCubit>().account?.id ?? "",
                                reference_id: Uuid().v1(),
                                transaction_id: Uuid().v1(),
                                amount: context.read<HomeDepositCubit>().total_amount,
                                createdAt: DateTime.now(),
                                name: context.read<HomeDepositCubit>().account?.name ?? "",
                                status: AppTransactionStatus.PENDING,
                                transaction_type: AppTransactionType.DEPOSIT,
                                id: Uuid().v1(),
                              );

                              confirmDepositModal(context, data);
                              logI(data.toJson());
                            }
                          },
                          color: context.read<HomeDepositCubit>().account == null ? Theme.of(context).highlightColor : Theme.of(context).primaryColor,
                          text: "Deposit",
                          textColor: context.read<HomeDepositCubit>().account == null ? Theme.of(context).primaryColor : kWhite,
                        ),
                      ],
                    ),
                  ),
                  khSpacer(80.h),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

GestureDetector IconInputButton({required IconData icon, void Function()? onTap, required Color color}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30.w,
      height: 40.h,
      decoration: BoxDecoration(color: color, borderRadius: radiusVal(2.r)),
      child: Icon(icon, size: 18.r),
    ),
  );
}

confirmDepositModal(BuildContext context, AppTransaction transaction) {
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
        Text("Deposit Money", style: Theme.of(context).textTheme.displayMedium),
        kh10Spacer(),
        Text(
          "Are you sure you want to deposit ${transaction.amount} FCFA to ${transaction.name} with account ID ${transaction.account_num}",
          textAlign: TextAlign.center,
        ),
        kh20Spacer(),
        submitButton(
          context: context,
          onPressed: () {
            context.pop();
            BlocProvider.of<TransactionCubit>(context).addTransaction(context: context, data: transaction);
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
