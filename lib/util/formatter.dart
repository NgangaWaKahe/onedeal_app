import 'package:intl/intl.dart';

class Formatter {
  static final oCcy = new NumberFormat("#,##0.00", "en_US");

  static String formatCurrent(dynamic number) {
    if (number == null) {
      return "0";
    }
    return oCcy.format(number);
  }

  static String fromCent(dynamic number) {
    return formatCurrent(convertToDouble(number) / 100);
  }

  static double convertToDouble(dynamic val) {
    if (val is int) {
      return val.toDouble();
    }
    return val;
  }
}
