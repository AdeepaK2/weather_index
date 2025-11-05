import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_data.dart';

class CacheService {
  static const String _weatherDataKey = 'cached_weather_data';

  /// Save weather data to cache
  Future<void> saveWeatherData(WeatherData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(data.toJson());
      await prefs.setString(_weatherDataKey, jsonString);
    } catch (e) {
      // If caching fails, log but don't crash
      print('Error saving to cache: $e');
    }
  }

  /// Load weather data from cache
  Future<WeatherData?> loadWeatherData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_weatherDataKey);

      if (jsonString == null) {
        return null;
      }

      final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
      return WeatherData.fromCache(jsonMap);
    } catch (e) {
      print('Error loading from cache: $e');
      return null;
    }
  }

  /// Clear cached weather data
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_weatherDataKey);
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  /// Check if cache exists
  Future<bool> hasCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(_weatherDataKey);
    } catch (e) {
      return false;
    }
  }
}
