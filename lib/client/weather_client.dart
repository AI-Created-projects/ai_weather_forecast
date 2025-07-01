import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:date_time/date_time.dart';
import 'package:weather_forecast/app/utils.dart';

class WeatherClient {
  Future<String> fetchForecast({DateRange? dateRange}) async {
    final dio = Dio(BaseOptions(baseUrl: 'https://api.open-meteo.com/v1'));
    final Map<String, dynamic> params = {
      'latitude': 50.1058339,
      'longitude': 14.540243,
      'hourly': [
        'temperature_2m',
        'apparent_temperature',
        'relative_humidity_2m',
        'rain',
        'showers',
        'snowfall',
        'precipitation_probability',
        'precipitation',
        'cloud_cover',
        'visibility',
      ].join(','),
      'timezone': 'Europe/Prague',
      if (dateRange != null) 'start_date': Utils.formatDate(dateRange.start),
      if (dateRange != null) 'end_date': Utils.formatDate(dateRange.end),
    };
    try {
      final response = await dio.get('/forecast', queryParameters: params);
      final data = response.data;
      return _convertOutput(data);
    } catch (e) {
      return 'Error: $e';
    }
  }

  String _convertOutput(Map<String, dynamic> data) {
    final units = data['hourly_units'];
    final hourly = data['hourly'];
    final int length = (hourly['time'] as List).length;

    List<Map<String, dynamic>> weatherList = [];

    for (int i = 0; i < length; i++) {
      weatherList.add({
        "time": hourly['time'][i],
        "temperature": hourly['temperature_2m'][i],
        "apparent_temperature": hourly['apparent_temperature'][i],
        "humidity": hourly['relative_humidity_2m'][i],
        "rain": hourly['rain'][i],
        "showers": hourly['showers'][i],
        "snowfall": hourly['snowfall'][i],
        "precipitation_probability": hourly['precipitation_probability'][i],
        "precipitation": hourly['precipitation'][i],
        "cloud_cover": hourly['cloud_cover'][i],
        "visibility": hourly['visibility'][i],
      });
    }

    final output = {"units": units, "weather": weatherList};

    return JsonEncoder.withIndent('  ').convert(output);
  }
}
