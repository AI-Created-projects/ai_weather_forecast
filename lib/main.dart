import 'package:date_time/date_time.dart';
import 'package:vader_console/vader_console.dart';
import 'package:weather_forecast/arguments.dart';
import 'package:weather_forecast/weather_client.dart';

void main(List<String> args) {
  runCliApp(arguments: args, commands: commands, parser: CliArguments.parse, app: app);
}

app(CliArguments args) async {
  final client = WeatherClient();
  final result = await client.fetchForecast(
    dateRange: DateRange(
      Date(year: 2025, month: 6, day: 6),
      Date(year: 2025, month: 6, day: 6),
    ),
  );
  print(result);
}
