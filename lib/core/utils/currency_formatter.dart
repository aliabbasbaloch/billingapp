import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final _formatter = NumberFormat('#,##0.00', 'en_US');

  static String format(double amount) {
    return 'PKR ${_formatter.format(amount)}';
  }

  static String formatCompact(double amount) {
    return _formatter.format(amount);
  }
}
