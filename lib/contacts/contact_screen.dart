import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sticky_az_list/sticky_az_list.dart';
import 'package:xoecollect/contacts/logic/contact/contact_cubit.dart';
import 'package:xoecollect/contacts/models/contact_model.dart';
import 'package:xoecollect/shared/components/appbar.dart';
import 'package:xoecollect/shared/components/auth_input.dart';
import 'package:xoecollect/shared/components/data_builder.dart';
import 'package:xoecollect/shared/components/loaders.dart';
import 'package:xoecollect/shared/utils/index.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  List<Account> accounts = [];
  bool loading = true;
  bool error = false;

  @override
  void initState() {
    BlocProvider.of<ContactCubit>(context).getAccounts(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContactCubit, ContactState>(
      builder: (context, state) {
        if (state is ContactFetchInitial) {
          loading = true;
          error = false;
        }
        if (state is ContactFiltered) {
          accounts = state.contacts;
        }
        if (state is ContactFetchError) {
          loading = false;
          error = true;
        }
        if (state is ContactFetchSuccess) {
          accounts = state.accounts;
          loading = false;
          error = false;
        }
        return Scaffold(
          appBar: appBar(
            context: context,
            title: "Accounts",
            centerTitle: true,
            style: Theme.of(context).textTheme.displayMedium,
            bgColor: Colors.transparent,
          ),
          body: SafeArea(
            child: Column(
              children: [
                // kh10Spacer(),
                Container(
                  padding: kPadding(20.w, 0),
                  child: authInput(
                    hint: "Search for contact",
                    context: context,
                    prefixIcon: Transform.scale(scale: 0.5, child: SvgPicture.asset(AppIcons.search)),
                    contentPadding: kPadding(20.w, 10.h),
                    hintStyle: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Theme.of(context).highlightColor.withOpacity(1),
                          fontWeight: FontWeight.w100,
                        ),
                    onChanged: (val) => BlocProvider.of<ContactCubit>(context).filter(val),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: kPadding(10.w, 0),
                    child: appLoaderBuilder(
                      error: error,
                      loading: loading,
                      loadingShimmer: Container(child: AppLoaders.loadingWidget(context)),
                      errorWidget: Container(
                        child: Center(child: Text("Error Finding contacts")),
                      ),
                      noDataWidget: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(SvgAsset.no_transaction),
                            kh20Spacer(),
                            Text("No Accounts found!"),
                          ],
                        ),
                      ),
                      hasData: accounts.length > 0,
                      child: StickyAzList(
                        items: accounts,
                        options: StickyAzOptions(
                          startWithSpecialSymbol: true,
                          overlayOptions: OverlayOptions(background: Theme.of(context).primaryColor, showOverlay: true),
                          listOptions: ListOptions(showSectionHeader: false),
                          scrollBarOptions: ScrollBarOptions(
                            background: Theme.of(context).highlightColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20.r),
                            jumpToSymbolsWithNoEntries: true,
                            heightFactor: 0.95.h,
                          ),
                        ),
                        builder: (context, index, item) {
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text(item.id.toString()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
