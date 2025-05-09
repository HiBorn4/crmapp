import 'package:intl/intl.dart';

String formatIndianCurrency(double amount) {
  final roundedAmount = amount.round();
  final format = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹ ',
    decimalDigits: 0,
  );
  return format.format(roundedAmount);
}
