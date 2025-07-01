import 'dart:math';

import 'package:date_time/date_time.dart';
import 'package:intl/intl.dart';

enum DaySpecifier {
  today,
  tomorrow,
  dayAfterTomorrow,
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

class Utils {
  static String formatDate(Date date) {
    final dateTime = DateTime(date.year, date.month, date.day);
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  static String formatDateWithDayName(DateTime date) {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];

    final dayName = days[date.weekday % 7];
    final day = date.day;
    final month = date.month;
    final year = date.year;
    final hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute ($dayName)';
  }

  static String escapeContent(String json) {
    return json.replaceAll('\\', r'\\').replaceAll('"', r'\"').replaceAll('\n', '\\n');
  }

  static DateTime getRandomDate(int year, int month) {
    final random = Random();
    final day = random.nextInt(27) + 1;
    final hour = random.nextInt(23);
    final minute = random.nextInt(59);
    final second = random.nextInt(59);
    return DateTime(year, month, day, hour, minute, second);
  }

  static DateTime getNextDate(DateTime fromDate, DaySpecifier specifier) {
    switch (specifier) {
      case DaySpecifier.today:
        return fromDate;

      case DaySpecifier.tomorrow:
        return fromDate.add(Duration(days: 1));

      case DaySpecifier.dayAfterTomorrow:
        return fromDate.add(Duration(days: 2));

      default:
        // Map enum to weekday number (Monday = 1, Sunday = 7)
        final Map<DaySpecifier, int> weekdayMap = {
          DaySpecifier.monday: DateTime.monday,
          DaySpecifier.tuesday: DateTime.tuesday,
          DaySpecifier.wednesday: DateTime.wednesday,
          DaySpecifier.thursday: DateTime.thursday,
          DaySpecifier.friday: DateTime.friday,
          DaySpecifier.saturday: DateTime.saturday,
          DaySpecifier.sunday: DateTime.sunday,
        };

        int targetWeekday = weekdayMap[specifier]!;
        int currentWeekday = fromDate.weekday;

        int daysUntilNext = (targetWeekday - currentWeekday + 7) % 7;
        if (daysUntilNext == 0) daysUntilNext = 7; // Same day -> next week's same day

        return fromDate.add(Duration(days: daysUntilNext));
    }
  }
}
