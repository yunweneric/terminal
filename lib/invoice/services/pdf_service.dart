import 'dart:io';

import 'package:http/http.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:share_plus/share_plus.dart';

class PdfApi {
  String logoName;

  PdfApi(this.logoName) {
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
    final url = file.path;
    Share.shareXFiles([file], text: 'Your reciept');
    print('File $url Shared');
  }

  Future<String> getlogo() async {
    final dir = await getApplicationDocumentsDirectory();
    final dirName = "$dir" + "/payunit.webp";
    print("dirName: $dirName");
    updateLogoName(dirName);
    return dirName;
  }

  void updateLogoName(logo) {
    this.logoName = logo;
  }

  String getLogoName() {
    getlogo();
    print(this.logoName);
    return this.logoName;
  }

  static getImage() {
    var url = "https://www.google.com/images/branding/googlelogo/2x/googlelogo_light_color_92x30dp.png";
    var response = get(Uri.parse(url)).then((value) => {
          print('Api data: ${value.bodyBytes}')

          // value.bodyBytes
        });
    // var data = response.bodyBytes;s
    // Timer.periodic(Duration(seconds: 5), (e) => data);
    return [];
  }
}
