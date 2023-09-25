import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/home/logic/home_deposit/home_deposit_cubit.dart';
import 'package:xoecollect/home/screens/widgets/success_deposit_modal.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

depositMoney({required BuildContext context, bool loading = false}) {
  List<int> amounts = [10000, 5000, 3000, 2500, 2000, 1000, 500, 250, 100, 50, 25];
  int add_factor = amounts.first;

  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  return AppSheet.simpleModal(
    onClose: () {},
    isDismissible: false,
    enableDrag: false,
    context: context,
    height: 700.h,
    alignment: Alignment.topCenter,
    child: BlocProvider(
      create: (context) => HomeDepositCubit(),
      child: BlocConsumer<HomeDepositCubit, HomeDepositState>(
        listener: (context, state) {
          logI(state);
        },
        builder: (context, state) {
          if (state is HomeDepositInitial) {
            amountController.text = Formaters.formatCurrency(state.amount) + " FCFA";
          }
          if (state is HomeDepositAdded) {
            amountController.text = Formaters.formatCurrency(state.amount) + " FCFA";
          }
          if (state is HomeDepositMinus) {
            amountController.text = Formaters.formatCurrency(state.amount) + " FCFA";
          }
          if (state is HomeDepositChangeAddFactor) {
            add_factor = state.factor;
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
                      authInput(
                        hint: "WJS98AHKP",
                        context: context,
                        label: "Account No.",
                        controller: accountController,
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
                                controller: amountController,
                                context: context,
                                label: "Amount",
                              ),
                            ),
                            kwSpacer(10.w),
                            Column(
                              children: [
                                IconInputButton(
                                  icon: Icons.add,
                                  onTap: () => BlocProvider.of<HomeDepositCubit>(context).addAmount(add_factor),
                                ),
                                khSpacer(2.h),
                                IconInputButton(
                                  icon: Icons.remove,
                                  onTap: () => BlocProvider.of<HomeDepositCubit>(context).minusAmount(add_factor),
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
                              backgroundColor: add_factor == amounts[index] ? Theme.of(context).primaryColor : null,
                              onPressed: () => BlocProvider.of<HomeDepositCubit>(context).changeAddFactor(amounts[index]),
                              label: Text(
                                Formaters.formatCurrency(amounts[index]),
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: add_factor == amounts[index] ? kWhite : kDark),
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
                      loading
                          ? Column(
                              children: [
                                kh20Spacer(),
                                kh20Spacer(),
                                AppLoaders.loadingWidget(context),
                                kh20Spacer(),
                                kh20Spacer(),
                              ],
                            )
                          : Column(
                              children: [
                                kh20Spacer(),
                                ListTile(
                                  leading: Text('Account Name'),
                                  trailing: Text("Ronald Richards", style: Theme.of(context).textTheme.titleMedium),
                                ),
                                ListTile(
                                  leading: Text('Account No'),
                                  trailing: Text("0215542874", style: Theme.of(context).textTheme.titleMedium),
                                ),
                                kh20Spacer(),
                              ],
                            ),
                      Divider(),
                      kh20Spacer(),
                      submitButton(
                        context: context,
                        onPressed: () {
                          context.pop();
                          successDepositModal(context: context, transaction: AppTransaction.fake());
                        },
                        text: "Deposit",
                      ),
                      kh10Spacer(),
                      submitButton(
                        textColor: Theme.of(context).primaryColor,
                        color: Theme.of(context).cardColor,
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                        context: context,
                        onPressed: () {
                          context.pop();
                        },
                        text: "Close",
                      ),
                    ],
                  ),
                ),
                kh10Spacer(),
              ],
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
      height: 30.h,
      decoration: BoxDecoration(color: icon == Icons.add ? kSuccess : kGrey, borderRadius: radiusVal(2.r)),
      child: Icon(icon, size: 18.r),
    ),
  );
}
