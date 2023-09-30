import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xoecollect/shared/components/buttons.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/radius.dart';
import 'package:xoecollect/shared/components/states_widgets.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/shared/utils/sizing.dart';
import 'package:xoecollect/shared/utils/svgs_assets.dart';
import 'package:xoecollect/transactions/logic/cubit/transaction_cubit.dart';
import 'package:xoecollect/transactions/screens/widgets/trannsaction_card.dart';

class TransactionList extends StatefulWidget {
  final double? height;
  const TransactionList({super.key, this.height});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  List<AppTransaction> transactions = [];
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    context.read<TransactionCubit>().fetchTransactions(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionCubit, TransactionState>(
      listener: (context, state) {
        logI(state);
        if (state is TransactionFetchInitial) {
          loading = true;
          error = false;
        }
        if (state is TransactionFetchError) {
          loading = false;
          error = true;
        }
        if (state is TransactionFetchSuccess) {
          transactions = state.transactions;
          loading = false;
          error = false;
        }
        if (state is TransactionFilterSuccess) {
          transactions = state.transactions;
          loading = false;
          error = false;
        }
      },
      builder: (context, state) {
        return Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: kWidth(context),
                  padding: kph(20.w),
                  child: appLoaderBuilder(
                    loading: loading,
                    error: error,
                    hasData: transactions.length > 0,
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: transactions.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (c, i) {
                        final transaction = transactions[i];
                        return transactionCard(context, transaction);
                      },
                      separatorBuilder: (c, i) => Container(margin: kpv(5.h), child: Divider(indent: 60.w)),
                    ),
                    // child: Column(children: []),
                    loadingShimmer: AppStateWidget.loadingWidget(context: context, height: widget.height ?? kHeight(context) / 2),
                    errorWidget: Container(
                      width: kWidth(context),
                      alignment: Alignment.center,
                      height: 200.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: radiusSm(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Could not load data"),
                          submitButton(
                            width: 90.w,
                            padding: kPadding(0.w, 6.h),
                            borderRadius: radiusVal(10.r),
                            context: context,
                            onPressed: () => {},
                            icon: Icon(Icons.refresh),
                            text: "Reload",
                            fontSize: 11.sp,
                          ),
                        ],
                      ),
                    ),
                    noDataWidget: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          kh20Spacer(),
                          kh20Spacer(),
                          SvgPicture.asset(SvgAsset.no_transaction),
                          kh20Spacer(),
                          Text("No transactions", style: Theme.of(context).textTheme.displayMedium),
                          kh10Spacer(),
                          Text("You haven't made any transactions."),
                        ],
                      ),
                    ),
                  ),
                ),
                khSpacer(30.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
