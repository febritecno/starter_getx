import 'package:intl/intl.dart';

class FormatNumber {
  static String convertNumber(dynamic number, int decimalDigit) {
    NumberFormat formattedNumber = NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: decimalDigit,
    );
    return formattedNumber.format(number);
  }
}
