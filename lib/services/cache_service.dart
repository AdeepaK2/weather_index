import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class CacheService {
  static const String _cacheKey = 'weather_data';

  Future<void> saveWeather(WeatherModel weather) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(weather.toJson()));
    } catch (e) {
      print('Error saving cache: $e');
    }
  }

  Future<WeatherModel?> loadWeather() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      
      if (cachedData != null) {
        final data = jsonDecode(cachedData);
        return WeatherModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error loading cache: $e');
      return null;
    }
  }
}

