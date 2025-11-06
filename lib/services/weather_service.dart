import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<WeatherModel> fetchWeather(double latitude, double longitude) async {
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    // Build request URL
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';

    // Make API call
    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      final temp = (data['main']['temp'] as num).toDouble();
      final wind = (data['wind']['speed'] as num).toDouble();
      final code = data['weather'][0]['id'] as int;
      final now = DateTime.now();
      final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      return WeatherModel(
        temperature: temp,
        windSpeed: wind,
        weatherCode: code,
        lastUpdated: timestamp,
        requestUrl: url,
      );
    } else {
      throw Exception('Failed to fetch weather: ${response.statusCode}');
    }
  }
}

