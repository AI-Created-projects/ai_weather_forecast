import 'dart:io';

import 'package:ai_clients/ai_clients.dart';
import 'package:date_time/date_time.dart';
import 'package:weather_forecast/generator/prompt_question.dart';
import 'package:weather_forecast/app/utils.dart';
import 'package:weather_forecast/client/weather_client.dart';

import '../app/examples.dart';

class TrainingDataGenerator {
  makeForecasts(DateTime date) async {
    final questions = QuestionData.getByDateTime(date);
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

    await _saveTrainingData(prompt, Utils.escapeContent(response));
  }

  Future<void> _saveTrainingData(String prompt, String response) async {
    final data =
    '''{"messages": [{"role": "user", "content": "$prompt"},{"role": "assistant", "content": "$response"}]}\n''';

    final dataDir = Directory('data');
    if (!await dataDir.exists()) await dataDir.create();

    final file = File('data/training_data.jsonl');
    await file.writeAsString(data, mode: FileMode.append);
  }
}