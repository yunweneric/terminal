import 'dart:io';

import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';
import 'package:xoecollect/invoice/services/invoice_generator.dart';
import 'package:xoecollect/shared/components/alerts.dart';
import 'package:xoecollect/shared/models/transaction/transation_model.dart';

class PdfService {
  String logoName;

  PdfService(this.logoName) {
    getlogo();
  }

  static Future<XFile> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);
    print('File $file is saved successfully!');
    XFile xFile = XFile(file.path);

    return xFile;
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
    print('File $url opened');
  }

  static Future printFile(XFile file) async {
    Share.shareXFiles([file], text: 'Your reciept');
  }

  static Future printTransaction(AppTransaction transaction) async {
    viewPdf(transaction);
    // List<Printer> printers = await Printing.listPrinters();

    // Printing.sharePdf(bytes: bytes)
    // Printing.directPrintPdf(
    //   printer: printers.first,
    //   onLayout: (format) {
    //     return viewPdf(transaction);
    //   },
    // );
  }

  Future<String> getlogo() async {
    final dir = await getApplicationDocumentsDirectory();
    final dirName = "$dir" + "/payunit.webp";
    this.logoName = dirName;
    return dirName;
  }

  static getImage() {
    var url = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_92x30dp.png";
    var response = get(Uri.parse(url)).then((value) => {print('Api data: ${value.bodyBytes}')});
    return [];
  }

  static viewPdf(AppTransaction transaction) {
    PdfPreview(
      maxPageWidth: 700,
      build: (format) => InvoiceGenerator.generate(transaction),
      onPrinted: (context) => showToastSuccess("Document printed successfully!"),
      onShared: (context) => showToastSuccess("Document printed successfully!"),
    );
  }

  static printDoc() async {
    await SunmiPrinter.initPrinter();
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.startTransactionPrint(true);
    // printLogoImage();
    await SunmiPrinter.lineWrap(1);

    await SunmiPrinter.printText('Tax Invoice',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.lineWrap(1);
    await SunmiPrinter.printText('Order # 1234',
        style: SunmiStyle(
          fontSize: SunmiFontSize.LG,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.line();
    await SunmiPrinter.printText('Main Branch',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          bold: true,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('London',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('xxxx-xxx-xx',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.printText('14',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.CENTER,
        ));
    await SunmiPrinter.line();
    await SunmiPrinter.printText('Order Type: Delivery',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.printText('Payment Type: Cash On Delivery',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ));

    await SunmiPrinter.printText('Cashier: N/A',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ));

    await SunmiPrinter.printText('Order Date: 20-July-2023',
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
          align: SunmiPrintAlign.LEFT,
        ));
    await SunmiPrinter.line();

// Print item details
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'Item',
        width: 9,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: 'Qty',
        width: 5,
        align: SunmiPrintAlign.CENTER,
      ),
      ColumnMaker(
        text: 'Dis',
        width: 5,
        align: SunmiPrintAlign.RIGHT,
      ),
      ColumnMaker(
        text: 'Tax',
        width: 5,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: 'Price',
        width: 5,
        align: SunmiPrintAlign.LEFT,
      ),
    ]);
    await SunmiPrinter.line();

    /// For Live data you have to attached you api response for list where
// data saved :-p

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
    ]; // Add more items as needed];

    for (var item in items) {
      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: item['name'],
          width: 11,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${item['quantity'] ?? ''}',
          width: 5,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: '${item['discountPrice'] ?? ''}',
          width: 5,
          align: SunmiPrintAlign.RIGHT,
        ),
        ColumnMaker(
          text: '${item['priceWithVAT'] ?? ''}',
          width: 6,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${item['price'] ?? ''}',
          width: 6,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);
    }
    await SunmiPrinter.line();

    await SunmiPrinter.bold();
    await SunmiPrinter.printRow(cols: [
      ColumnMaker(
        text: 'TOTAL',
        width: 25,
        align: SunmiPrintAlign.LEFT,
      ),
      ColumnMaker(
        text: '2031',
        width: 6,
        align: SunmiPrintAlign.RIGHT,
      ),
    ]);
    await SunmiPrinter.lineWrap(2);
    await SunmiPrinter.line();
    await SunmiPrinter.cut();
    await SunmiPrinter.exitTransactionPrint(true);
  }
}
