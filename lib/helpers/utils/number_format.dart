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

  static String convertRupiah(String number,
      {symbol = 'Rp. ', customPattern, decimalDigit = 0}) {
    NumberFormat formattedNumber = NumberFormat.currency(
      // customPattern: "#,##0",
      // locale: 'id',
      customPattern: customPattern,
      symbol: symbol,
      decimalDigits: decimalDigit,
    );
    var parsed = number.replaceAll(RegExp('[^0-9]'), '');
    return formattedNumber.format(int.parse(parsed));
  }
}
