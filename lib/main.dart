import 'dart:io';

import 'package:ai_clients/ai_clients.dart';
import 'package:date_time/date_time.dart';
import 'package:vader_console/vader_console.dart';
import 'package:weather_forecast/arguments.dart';
import 'package:weather_forecast/utils.dart';
import 'package:weather_forecast/weather_client.dart';

import 'examples.dart';

void main(List<String> args) {
  runCliApp(arguments: args, commands: commands, parser: CliArguments.parse, app: app);
}

app(CliArguments args) async {
  final dates = [
    Utils.getRandomDate(2025, 4),
    Utils.getRandomDate(2025, 4),
    Utils.getRandomDate(2025, 5),
    Utils.getRandomDate(2025, 5),
    Utils.getRandomDate(2025, 6),
    Utils.getRandomDate(2025, 6),
    DateTime.now(),
  ];
  for (final date in dates) {
    await makeForecasts(date);
  }
}

makeForecasts(DateTime date) async {
  final questions = getQuestionData(date);
  for (final questionData in questions) {
    print(questionData);
    await makeForecast(
      question: questionData.question,
      now: date,
      forecastDay: questionData.forecastDay,
    );
  }
  print('');
}

makeForecast({required String question, required DateTime now, required DateTime forecastDay}) async {
  final forecastResult = await WeatherClient().fetchForecast(
    dateRange: DateRange(forecastDay.date, forecastDay.date),
  );

  final currentDate = Utils.formatDateWithDayName(now);

  var response = await AiClients.openAi().query(
    delay: Duration(seconds: 5),
    system:
        'Podle dat která máš v kontextu odpověz jaké bude nebo je počasí. '
        'Odpověď musí být v podobném formátu jako je v příkladech.',
    prompt: question,
    contexts: [
      Context(name: 'current_date', value: currentDate),
      Context(name: 'examples', value: examples),
      Context(name: 'forecast', value: forecastResult),
    ],
  );

  final prompt = Utils.escapeContent(
    buildPrompt(
      prompt: question,
      contexts: [
        Context(name: 'now', value: currentDate),
        Context(name: 'forecast', value: forecastResult),
      ],
    ),
  );

  await saveTrainingData(prompt, Utils.escapeContent(response));
}

Future<void> saveTrainingData(String prompt, String response) async {
  final data =
      '''{"messages": [{"role": "user", "content": "$prompt"},{"role": "assistant", "content": "$response"}]}\n''';

  final dataDir = Directory('data');
  if (!await dataDir.exists()) await dataDir.create();

  final file = File('data/training_data.jsonl');
  await file.writeAsString(data, mode: FileMode.append);
}

String buildPrompt({required String prompt, List<Context>? contexts}) {
  final sb = StringBuffer(prompt);
  if (contexts != null && contexts.isNotEmpty) {
    for (final context in contexts) {
      sb.writeln('\n');
      sb.writeln('=========== ${context.name == null ? '' : context.name!.toUpperCase()} CONTEXT ===========');
      sb.writeln(context.value);
      sb.writeln('=============================');
    }
  }
  return sb.toString();
}

Map<DaySpecifier, String> questions = {
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

List<QuestionData> getQuestionData(DateTime now) {
  return questions.entries.map((q) => QuestionData(now, Utils.getNextDate(now, q.key), q.value)).toList();
}

class QuestionData {
  final DateTime now;
  final DateTime forecastDay;
  final String question;

  QuestionData(this.now, this.forecastDay, this.question);

  @override
  String toString() {
    return 'QuestionData{now: $now, forecastDay: $forecastDay, question: $question}';
  }
}
