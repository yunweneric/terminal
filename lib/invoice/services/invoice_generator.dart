import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xoecollect/invoice/services/pdf_service.dart';
import 'package:xoecollect/shared/helpers/formaters.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';
import './docs/logo1.dart' as im1;

class InvoiceGenerator {
  static FutureOr<XFile?> generateFile(AppTransaction transaction) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) => [
          buildInvoice(transaction),
          buildFooter(),
        ],
      ),
    );
    return PdfService.saveDocument(name: 'reciept${DateTime.now()}.pdf', pdf: pdf);
  }

  static FutureOr<Uint8List> generate(AppTransaction transaction) async {
    final pdf = Document();
    pdf.addPage(Page(build: (context) => buildInvoice(transaction))
        // MultiPage(
        //   mainAxisAlignment: pw.MainAxisAlignment.start,
        //   build: (context) => [
        //     buildInvoice(transaction),
        //     // buildFooter(),
        //   ],
        // ),
        );

    return pdf.save();

    // return PdfApi.saveDocument(name: 'reciept${DateTime.now()}.pdf', pdf: pdf);
  }

  static Widget buildHeader(transactionId) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarcodeWidget(
                height: 100,
                width: 150,
                margin: EdgeInsets.only(bottom: 30.0),
                textStyle: TextStyle(
                  fontSize: 20.0,
                  height: 2.0,
                  fontWeight: FontWeight.normal,
                ),
                barcode: Barcode.qrCode(),
                data: 'https://payunit.net/',
              ),
            ],
          ),
          Image(MemoryImage(Uint8List.fromList(im1.list)), height: 60),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            child: Column(
              children: [
                Text(
                  'Powered by PayUnit',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'https://payunit.net/',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    height: 5.0,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ],
      );

  static Widget buildFooter() => SizedBox(height: 10.0, child: Text(''));

  static Widget buildInvoice(AppTransaction transaction) => Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  k10Spacer(),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${Formaters.formatCurrency(transaction.amount)} FCFA",
                          style: TextStyle(fontSize: 50.sp, fontWeight: FontWeight.bold),
                        ),
                        k10Spacer(),
                        Text(transaction.name, style: TextStyle(fontSize: 25.sp)),
                        Text(transaction.transaction_id, style: TextStyle(fontSize: 22.sp)),
                      ],
                    ),
                  ),
                  khSpacer(15.h),
                  Divider(),
                  khSpacer(15.h),
                  Container(
                    decoration: BoxDecoration(
                      // color: PdfColor(0.9, 0.9, 0.9, 0.5),
                      borderRadius: BorderRadius.circular(5.r),
                      // border: Border.all(color: PdfColor(0.9, 0.9, 0.9, 0.5)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 20.h),
                    child: Column(
                      children: [
                        k10Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title("You Deposited", "${Formaters.formatCurrency(transaction.amount)} FCFA"),
                            k10Spacer(),
                            title("To", transaction.name),
                            k10Spacer(),
                            title("Account No.", transaction.account_num),
                            k10Spacer(),
                            title('Date:', Formaters.formatDate(transaction.createdAt)),
                            k10Spacer(),
                            title("Transaction Id", transaction.transaction_id),
                            k10Spacer(),
                            title("Reference Id", transaction.reference_id),
                            Divider(thickness: 1.0),
                            k10Spacer(),
                            Text("Office Application Design Bill", style: TextStyle(fontSize: 22.sp)),
                            k10Spacer(),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );

  static pw.SizedBox k10Spacer() => SizedBox(height: 10.0);
  static pw.SizedBox k20Spacer() => SizedBox(height: 20.0);
  static pw.SizedBox khSpacer(double? height) => SizedBox(height: height ?? 20.0);

  static pw.Container title(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 25.sp),
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.normal),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
    // return Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceAround,
    //   children: [
    //     Text(
    //       title,
    //       style: TextStyle(fontSize: 24.0, height: 15.0, fontWeight: FontWeight.normal),
    //     ),
    //     Text(
    //       value,
    //       style: TextStyle(fontSize: 24.0, height: 15.0, fontWeight: FontWeight.normal),
    //     )
    //   ],
    // );
  }
}
