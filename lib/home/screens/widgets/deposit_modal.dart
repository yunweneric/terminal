import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/home/logic/home_deposit/home_deposit_cubit.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';

depositMoney({required BuildContext context, required List<int> amounts, bool loading = false}) {
  int add_factor = amounts.first;
  TextEditingController accountController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  return AppSheet.simpleModal(
    onClose: () {},
    isDismissible: true,
    context: context,
    height: 600.h,
    alignment: Alignment.topCenter,
    child: BlocConsumer<HomeDepositCubit, HomeDepositState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is HomeDepositInitial) {
          amountController.text = "500";
        }
        if (state is HomeDepositAdded) {
          amountController.text = state.amount.toString();
        }
        if (state is HomeDepositMinus) {
          amountController.text = state.amount.toString();
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
                              IconInputButton(icon: Icons.remove, onTap: () {}),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              kh20Spacer(),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.start,
                runSpacing: 10.w,
                spacing: 20.w,
                children: amounts
                    .map(
                      (e) => Chip(
                        onDeleted: () => BlocProvider.of<HomeDepositCubit>(context).changeAddFactor(e),
                        label: Text(Formaters.formatCurrency(e), style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    )
                    .toList(),
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
                      },
                      text: "Proceed",
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
