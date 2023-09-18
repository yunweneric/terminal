import 'dart:math';
import 'package:intl/intl.dart';

class Formaters {
  static String formatNumber(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    } else if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
  }

  static String sumAndFormat(List<int> numbers) {
    if (numbers.length == 0) return "0";
    int sum = numbers.reduce((value, element) => value + element);
    return formatNumber(sum);
  }

  static String capitalize(String string) {
    if (string.isEmpty) return string;
    return string[0].toUpperCase() + string.substring(1);
  }

  static bool validateEmail(String value) {
    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(p);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool isValidUrl(String url) {
    final Uri? uri = Uri.tryParse(url);
    return !uri!.hasAbsolutePath ? true : false;
  }

  static String formatDate(DateTime? date) {
    if (date == null) return "----";
    String formattedDate = DateFormat('dd, MMMM, yyyy').format(date);
    return formattedDate;
  }

  static String getFirstLetter(String str) {
    return str.substring(0, 1);
  }

  static String formatCurrency(String amount) {
    final formatter = new NumberFormat("#,##0", "en_US");
    return formatter.format(int.parse(amount));
  }

  static String formatCoordinates(double val) {
    return val.toStringAsFixed(4);
  }

  static String timeToHumans(DateTime date, String local) {
    final now = DateTime.now();
    // final date = timestamp.toDate();
    final delta = now.difference(date);
    if (delta < Duration(minutes: 1)) {
      return local == "en" ? "just now" : "à l'instant";
    } else if (delta < Duration(hours: 1)) {
      final minutes = delta.inMinutes;
      return local == "en" ? "${minutes} minute${minutes > 1 ? 's' : ''} ago" : "il y'a ${minutes} minute${minutes > 1 ? 's' : ''}";
    } else if (delta < Duration(days: 1)) {
      final hours = delta.inHours;
      return local == "en" ? "${hours} hour${hours > 1 ? 's' : ''} ago" : "il y'a ${hours} heure${hours > 1 ? 's' : ''}";
    } else if (delta < Duration(days: 2)) {
      return local == "en" ? "yesterday" : "hier";
    } else if (delta < Duration(days: 7)) {
      final days = delta.inDays;
      return local == "en" ? "${days} day${days > 1 ? 's' : ''} ago" : "il y'a  ${days} jour${days > 1 ? 's' : ''}";
    } else if (delta < Duration(days: 365)) {
      final months = max(1, (delta.inDays / 30).floor());
      return local == "en" ? "${months} month${months > 1 ? 's' : ''} ago" : "il y'a ${months} mois${months > 1 ? 's' : ''}";
    } else {
      final years = (delta.inDays / 365).floor();
      return local == "en" ? "${years} year${years > 1 ? 's' : ''} ago" : "il y'a ${years} année${years > 1 ? 's' : ''}";
    }
  }

  static String getMonthName(DateTime now) {
    List<String> monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    String monthName = monthNames[now.month - 1];
    return monthName;
  }
}
