import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:xoecollect/home/logic/home_deposit/home_deposit_cubit.dart';
import 'package:xoecollect/invoice/services/pdf_service.dart';
import 'package:xoecollect/shared/components/bottom_sheets.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/header_amount.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/theme/colors.dart';
import 'package:xoecollect/transactions/logic/cubit/transaction_cubit.dart';

Widget Item(BuildContext context, String title, String value) {
  return Container(
    margin: EdgeInsets.only(bottom: 20.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        kwSpacer(20.w),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}

successDepositModal({required BuildContext context, required AppTransaction transaction}) {
  return AppSheet.simpleModal(
    onClose: () {},
    isDismissible: true,
    enableDrag: true,
    context: context,
    height: 700.h,
    alignment: Alignment.topCenter,
    child: BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        if (state is TransactionGeneratePdfInitial) {
          AppLoaders.showLoader(context: context);
        }
        if (state is TransactionGeneratePdfInitial) {
          AppLoaders.dismissEasyLoader();
        }
        if (state is TransactionGeneratePdfSuccess) {
          AppLoaders.dismissEasyLoader();
          PdfApi.printFile(state.file);
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              kh20Spacer(),
              SvgPicture.asset(AppIcons.success_check),
              // kh20Spacer(),
              // headerAmount(
              //   title: "Deposited to Ronald Richards",
              //   amount: transaction.amount,
              //   amountColor: Theme.of(context).primaryColor,
              //   textColor: Theme.of(context).primaryColor,
              //   context: context,
              // ),
              Padding(
                padding: kAppPadding(),
                child: Column(
                  children: [
                    kh10Spacer(),
                    Column(
                      children: [
                        kh20Spacer(),
                        Item(context, "You Deposited", Formaters.formatCurrency(transaction.amount) + " Fcfa"),
                        Item(context, "To", transaction.name),
                        Item(context, "Account No.", transaction.account_num),
                        Item(context, "Status", transaction.status),
                        Item(context, "Date", Formaters.formatDate(transaction.createdAt)),
                        Item(context, "Transaction ID", transaction.transaction_id),
                        Item(context, "Reference ID", transaction.reference_id),
                      ],
                    ),
                    Divider(),
                    kh10Spacer(),
                    submitButton(
                      context: context,
                      onPressed: () {
                        context.pop();
                        BlocProvider.of<TransactionCubit>(context).generatePdf(
                          transaction.transaction_id,
                          transaction.amount,
                          "678308472",
                        );
                      },
                      text: "Print Receipt",
                    ),
                    kh20Spacer(),
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
