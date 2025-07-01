import 'package:vader_console/vader_console.dart';
import 'package:weather_forecast/app/arguments.dart';
import 'package:weather_forecast/generator/training_data_generator.dart';
import 'package:weather_forecast/app/utils.dart';

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

  final generator = TrainingDataGenerator();
  for (final date in dates) {
    await generator.makeForecasts(date);
  }
}

