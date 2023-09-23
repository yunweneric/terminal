import 'dart:async';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xoecollect/invoice/services/pdf_service.dart';
import './docs/logo1.dart' as im1;
import './docs/payunitlogo.dart' as payunitlogo;

class PdfInvoiceApi {
  static Future<XFile> generate(
    transactionId,
    amount,
    phoneNumber,
  ) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) => [
          buildInvoice(transactionId, amount, phoneNumber),
          // buildHeader(transactionId),
          buildFooter(),
        ],
      ),
    );

    return PdfApi.saveDocument(name: 'reciept${DateTime.now()}.pdf', pdf: pdf);
  }

  static Widget generateTime() {
    final dateObj = DateTime.now();
    // final format = new DateFormat('Hh:Hm:ss');
    final format = new DateFormat('H:m:s');
    // final hourFormat = DateFormat('hh');
    // final hourFormat = DateFormat('Hms');
    final time = format.format(dateObj);
    // final currenthour = hourFormat.format(dateObj);

    return Text(
      // int.parse(currenthour) > 12 ? '$time PM' : '$time AM',
      '$time',
      style: TextStyle(
        fontSize: 24.0,
        height: 2.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget formattedAmount(int amount) {
    final actualAmount = NumberFormat.decimalPattern().format(amount);
    return Text(
      '$actualAmount XAF',
      style: TextStyle(
        fontSize: 35.0,
        height: 2.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget generateDate() {
    final dateObj = DateTime.now();
    final format = new DateFormat('dd/MM/yyyy');
    final date = format.format(dateObj);
    return Text('$date',
        style: TextStyle(
          fontSize: 24.0,
          height: 2.0,
          fontWeight: FontWeight.bold,
        ));
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
  static Widget buildFooter() => SizedBox(
        height: 10.0,
        child: Text(''),
      );
  static Widget buildInvoice(transactionId, amount, phoneNumber) => Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Center(
                      child: Image(
                        MemoryImage(Uint8List.fromList(im1.list)),
                        height: 100,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SOREPCO',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        'BP: 153 Douala',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Tel: +237 678 98 76 55',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Douala, Cameroon',
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.0),
                  Text(
                    'Transaction Details',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      height: 2.0,
                    ),
                  ),
                  Divider(endIndent: 100.0, indent: 5.0, thickness: 3.0),
                  SizedBox(height: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title(title: "Total Amount: "),
                      SizedBox(height: 5.0),
                      formattedAmount(int.parse('$amount')),
                      SizedBox(height: 10.0),
                      title(title: "Transaction Id: "),
                      SizedBox(height: 5.0),
                      Text(
                        transactionId,
                        style: TextStyle(
                          fontSize: 24.0,
                          height: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      title(title: "Cashier Name: "),
                      SizedBox(height: 5.0),
                      Text(
                        "Kemfang Tcheutchie Cabrel",
                        style: TextStyle(
                          fontSize: 24.0,
                          height: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      title(title: 'Date:'),
                      SizedBox(height: 5.0),
                      generateDate(),
                      SizedBox(height: 10.0),
                      Text(
                        'Time:',
                        style: TextStyle(
                          fontSize: 24.0,
                          height: 2.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      generateTime(),
                      SizedBox(height: 20.0),
                      Divider(endIndent: 0.0, indent: 0.0, thickness: 3.0),
                      SizedBox(height: 10.0),
                      pw.Column(children: [
                        Text(
                          'Thanks for trusting Us',
                          style: TextStyle(
                            fontSize: 24.0,
                            height: 2.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          pw.Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              "Powered by",
                              style: TextStyle(
                                fontSize: 20.0,
                                height: 2.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              "www.payunit.net",
                              style: TextStyle(
                                fontSize: 15.0,
                                height: 2.0,
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ]),
                          SizedBox(width: 20.0),
                          Image(
                            MemoryImage(Uint8List.fromList(payunitlogo.list)),
                            height: 50,
                          ),
                        ])
                      ]),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  static pw.Text title({title}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 24.0,
        height: 15.0,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
