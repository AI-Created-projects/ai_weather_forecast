import 'package:vader_console/vader_console.dart';
import 'package:weather_forecast/arguments.dart';

void main(List<String> args) {
  runCliApp(
    arguments: args,
    commands: commands,
    parser: CliArguments.parse,
    app: (args) {
      print("Main part of my app...");
      print("Message: ${args.message}");
    },
  );
}
