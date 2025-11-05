import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/weather_data.dart';
import '../utils/index_utils.dart';
import 'cache_service.dart';

class WeatherService {
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final CacheService _cacheService = CacheService();

  /// Generate the request URL for the API call
  String generateRequestUrl(double latitude, double longitude) {
    final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
    return '$_baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
  }

  /// Fetch weather data for a given student index
  Future<WeatherData> fetchWeatherForIndex(String index) async {
    // Validate the index
    if (!IndexUtils.isValidIndex(index)) {
      throw Exception('Invalid index format. Must contain at least 4 digits.');
    }

    // Derive coordinates from index
    final coordinates = IndexUtils.deriveCoordinates(index);
    final url = generateRequestUrl(coordinates.latitude, coordinates.longitude);

    try {
      // Check connectivity
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult == ConnectivityResult.none;

      if (isOffline) {
        // Try to load from cache
        final cachedData = await _cacheService.loadWeatherData();
        if (cachedData != null) {
          return cachedData.copyWith(isCached: true);
        }
        throw Exception('No internet connection and no cached data available');
      }

      // Make the API request
      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final weatherData = WeatherData.fromJson(
          jsonData,
          url,
          coordinates.latitude,
          coordinates.longitude,
        );

        // Cache the successful response
        await _cacheService.saveWeatherData(weatherData);

        return weatherData;
      } else {
        // Try to return cached data on API error
        final cachedData = await _cacheService.loadWeatherData();
        if (cachedData != null) {
          return cachedData.copyWith(isCached: true);
        }
        throw Exception('Failed to fetch weather data: ${response.statusCode}');
      }
    } catch (e) {
      // Try to return cached data on any error
      final cachedData = await _cacheService.loadWeatherData();
      if (cachedData != null) {
        return cachedData.copyWith(isCached: true);
      }
      rethrow;
    }
  }

  /// Check if device is online
  Future<bool> isOnline() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
