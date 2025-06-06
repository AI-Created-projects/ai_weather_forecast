import 'package:date_time/date_time.dart';
import 'package:intl/intl.dart';

class Utils {
  static String formatDate(Date date) {
    final dateTime = DateTime(date.year, date.month, date.day);
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }
}