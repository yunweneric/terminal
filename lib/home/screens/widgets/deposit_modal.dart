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
import 'package:xoecollect/transactions/data/transaction_service.dart';
import 'package:xoecollect/transactions/logic/cubit/transaction_cubit.dart';

depositMoney({required BuildContext context, bool loading = false}) {
  List<int> amounts = [25, 50, 100, 200, 500, 1000, 2000, 2500, 3000, 5000, 10000];
  int add_factor = amounts.first;

  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  bool loading = false;
  return AppSheet.simpleModal(
    onClose: () {},
    isDismissible: false,
    enableDrag: false,
    context: context,
    height: kHeight(context),
    alignment: Alignment.topCenter,
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

          return BlocListener<TransactionCubit, TransactionState>(
            listener: (context, state) async {
              if (state is TransactionAddInitial) AppLoaders.showLoader(context: context);
              if (state is TransactionAddError) {
                AppLoaders.dismissEasyLoader();
                AppSheet.appErrorSheet(context: context, message: state.response.message);
              }
              if (state is TransactionAddSuccess) {
                SMSService smsService = SMSService();
                BaseService base_service = BaseService();
                AppTransaction updated = state.transactions;
                updated.status = AppTransactionStatus.SUCCESS;
                await base_service.baseUpdate(data: updated.toJson(), collectionRef: AppRoutes.transactions);
                await smsService.sendSMS(
                  "+237672141321",
                  "You have successfully deposited a sum of ${context.watch<HomeDepositCubit>().initial_amount} to the account ${context.watch<HomeDepositCubit>().account?.name}",
                );
                context.pop();
                successDepositModal(context: context, transaction: AppTransaction.fake());
              }
            },
            child: SingleChildScrollView(
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
                          controller: accountController,
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
                                  // readOnly: true,
                                  // contentPadding: kPadding(10.w, 25.h),
                                  controller: amountController,
                                  context: context,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    BlocProvider.of<HomeDepositCubit>(context).updateSum(val);
                                  },
                                  label: "Amount",
                                ),
                              ),
                              kwSpacer(10.w),
                              // Column(
                              //   children: [
                              //     IconInputButton(
                              //       icon: Icons.add,
                              //       onTap: () => BlocProvider.of<HomeDepositCubit>(context).addOperator(isAddition: true),
                              //     ),
                              //     khSpacer(2.h),
                              //     IconInputButton(
                              //       icon: Icons.remove,
                              //       onTap: () => BlocProvider.of<HomeDepositCubit>(context).addOperator(isAddition: false),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  kh20Spacer(),
                  // Container(
                  //   height: 30.h,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     itemCount: amounts.length,
                  //     itemBuilder: ((context, index) {
                  //       return Row(
                  //         children: [
                  //           if (index == 0) kwSpacer(20.w),
                  //           Container(
                  //             margin: EdgeInsets.only(right: 20.w),
                  //             child: ActionChip(
                  //               padding: kPadding(10.w, 0.h),
                  //               backgroundColor: add_factor == amounts[index] ? Theme.of(context).primaryColor : null,
                  //               onPressed: () => BlocProvider.of<HomeDepositCubit>(context).addValue(amounts[index]),
                  //               label: Text(
                  //                 Formaters.formatCurrency(amounts[index]),
                  //                 style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: add_factor == amounts[index] ? kWhite : kDark),
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     }),
                  //   ),
                  // ),
                  // kh20Spacer(),
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
                                trailing: Text(context.watch<HomeDepositCubit>().account?.name ?? "", style: Theme.of(context).textTheme.titleMedium),
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
                            if (context.watch<HomeDepositCubit>().account == null) {
                              AppModal.showErrorAlert(context: context, title: "Transaction Status", desc: "Please enter a valid account");
                              return;
                            }
                            if (context.watch<HomeDepositCubit>().initial_amount != 0) {
                              BlocProvider.of<TransactionCubit>(context).addTransaction(
                                context: context,
                                data: AppTransaction(
                                  account_num: context.watch<HomeDepositCubit>().account?.id ?? "",
                                  reference_id: Uuid().v1(),
                                  transaction_id: Uuid().v1(),
                                  amount: context.watch<HomeDepositCubit>().initial_amount,
                                  createdAt: DateTime.now(),
                                  name: context.watch<HomeDepositCubit>().account?.name ?? "",
                                  status: AppTransactionStatus.PENDING,
                                  id: Uuid().v1(),
                                ),
                              );
                            }
                          },
                          text: "Deposit",
                        ),
                      ],
                    ),
                  ),
                  khSpacer(80.h),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

GestureDetector IconInputButton({required IconData icon, void Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30.w,
      height: 40.h,
      decoration: BoxDecoration(color: icon == Icons.add ? kSuccess : kGrey, borderRadius: radiusVal(2.r)),
      child: Icon(icon, size: 18.r),
    ),
  );
}
