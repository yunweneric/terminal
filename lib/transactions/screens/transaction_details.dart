import 'package:flutter/material.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import 'package:xoecollect/transactions/screens/widgets/header-body.dart';
import 'package:xoecollect/transactions/screens/widgets/header_section.dart';

class TransactionDetails extends StatefulWidget {
  final AppTransaction transaction;
  const TransactionDetails({super.key, required this.transaction});

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            HeaderSection(transaction: widget.transaction),
            HeaderBody(transaction: widget.transaction),
          ],
        ),
      ),
    );
  }
}
