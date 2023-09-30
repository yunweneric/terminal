import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xoecollect/shared/components/alerts.dart';

class Helpers {
  static String base_account = "8376";
  static void contactPhone({String? phone, required BuildContext context}) async {
    if (phone == null) {
      Future.delayed(3000.ms);
      showToastError("Driver contact not available. We will redirect you to EZTrip Admin!");
      phone = "+237690279929";
    }
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (Platform.isAndroid) {
      (!await launchUrl(phoneUri));
    } else {
      (!await launchUrl(phoneUri));
    }
  }

  static void contactWhatsApp({String? phone, required BuildContext context, required String message}) async {
    if (phone == null) {
      showToastError("Driver contact not available. We will redirect you to EZTrip Admin!");
      Future.delayed(3000.ms);
      phone = "+237690279929";
      Future.delayed(3000.ms);
    }
    var whatsappURlAndroid = "whatsapp://send?phone=" + phone + "&text=$message";
    var whatsappURLIos = "https://wa.me/$phone?text=${Uri.tryParse(message)}";
    if (Platform.isAndroid) {
      (!await launchUrl(Uri.parse(whatsappURlAndroid)));
    } else {
      (!await launchUrl(Uri.parse(whatsappURLIos)));
    }
  }

  static generateCode() {
    return Random().nextInt(8999) + 1000;
  }
}
