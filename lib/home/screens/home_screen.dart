import 'package:flutter/material.dart';
import 'package:xoecollect/contacts/data/contact_service.dart';
import 'package:xoecollect/home/screens/widgets/home_header.dart';
import 'package:xoecollect/shared/utils/logger_util.dart';
import 'package:xoecollect/transactions/data/transaction_service.dart';
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
    List<dynamic> items = [
      {
        'name': 'Item 1',
        'quantity': 2,
        'discountPrice': 10.99,
        'priceWithVAT': 13.50,
        'price': 12.00,
      },
      {
        'name': 'Item 2',
        'quantity': 1,
        'discountPrice': 8.50,
        'priceWithVAT': 10.20,
        'price': 9.00,
      },
      // Add more items as needed
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // enterCodeModal(context, AppTransaction.fake());

          // var res = await ServiceLocator.getIt<TransactionService>().seedTransactions();
          // var res = await ServiceLocator.getIt<ChartService>().getChartData();
          // logI(res.data['data']);
          // var res = await contactService.seedContact();
          // var t = AppTransaction.fromJson(res.data);
          // logI(Formaters.formatDate(t.createdAt));
          // }),
//
          TransactionService transactionService = TransactionService();
          ContactService contactService = ContactService();
          final res = await transactionService.seedTransactions();
          await contactService.seedContact();
          logI(res.toJson());

          // AppLoaders.showLoader(context: context);

          // PdfService.printTransaction(AppTransaction.fake());
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          height: kHeight(context),
          child: Column(
            children: [
              HeaderSection(),
              TransactionList(),
            ],
          ),
        ),
      ),
    );
  }
}
