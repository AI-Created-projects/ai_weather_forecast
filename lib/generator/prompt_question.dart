import 'package:weather_forecast/app/utils.dart';

class QuestionData {
  final DateTime now;
  final DateTime forecastDay;
  final String question;

  QuestionData(this.now, this.forecastDay, this.question);

  @override
  String toString() {
    return 'QuestionData{now: $now, forecastDay: $forecastDay, question: $question}';
  }

  static List<QuestionData> getByDateTime(DateTime now) {
    return _questions.entries.map((q) => QuestionData(now, Utils.getNextDate(now, q.key), q.value)).toList();
  }

  static const Map<DaySpecifier, String> _questions = {
    DaySpecifier.today: 'Jaké je dnes počasí?',
    DaySpecifier.tomorrow: 'Jaké bude zítra počasí?',
    DaySpecifier.dayAfterTomorrow: 'Jaké bude pozítří počasí?',
    DaySpecifier.monday: 'Jaké bude v pondělí počasí?',
    DaySpecifier.tuesday: 'Jaké bude v úterý počasí?',
    DaySpecifier.wednesday: 'Jaké bude ve středu počasí?',
    DaySpecifier.thursday: 'Jaké bude ve čtvrtek počasí?',
    DaySpecifier.friday: 'Jaké bude v pátek počasí?',
    DaySpecifier.saturday: 'Jaké bude v sobotu počasí?',
    DaySpecifier.sunday: 'Jaké bude v neděli počasí?',
  };
}
