import 'package:flutter/material.dart';
import 'package:xoecollect/home/screens/widgets/home_header.dart';
import 'package:xoecollect/invoice/services/pdf_service.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/transactions/screens/widgets/transaction_list.dart';
import 'package:xoecollect/shared/models/users/user_model.dart';
import 'package:xoecollect/shared/utils/sizing.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loadKyc = true;
  bool loadingUser = true;
  bool loadedBoth = false;
  bool loadingFeeds = false;
  bool errorUser = false;
  bool errorFeeds = false;
  bool errorKyc = false;
  double percentage = 0;
  AppUser? user;

  @override
  void initState() {
    user = AppUser.fake();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TransactionService transactionService = TransactionService();
          // ContactService contactService = ContactService();
          // var res = await transactionService.seedTransactions();
          // var res = await contactService.seedContact();
          // logI(res.toJson());

          // AppLoaders.showLoader(context: context);

          PdfService.printTransaction(AppTransaction.fake());
        },
      ),
      body: Container(
        height: kHeight(context),
        child: Column(
          children: [
            HeaderSection(),
            TransactionList(),
          ],
        ),
      ),
    );
  }
}
