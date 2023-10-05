import 'dart:io';

import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
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
    List<Printer> printers = await Printing.listPrinters();
    Printing.directPrintPdf(
      printer: printers.first,
      onLayout: (format) {
        return viewPdf(transaction);
      },
    );
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
}
