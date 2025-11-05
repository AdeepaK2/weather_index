import 'package:flutter/material.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';
import '../services/cache_service.dart';
import '../widgets/index_input.dart';
import '../widgets/weather_display.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _indexController = TextEditingController(
    text: '224110P', // Prefilled example
  );
  final WeatherService _weatherService = WeatherService();
  final CacheService _cacheService = CacheService();

  WeatherData? _weatherData;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCachedWeather();
  }

  @override
  void dispose() {
    _indexController.dispose();
    super.dispose();
  }

  /// Load cached weather data on startup
  Future<void> _loadCachedWeather() async {
    final cachedData = await _cacheService.loadWeatherData();
    if (cachedData != null && mounted) {
      setState(() {
        _weatherData = cachedData.copyWith(isCached: true);
      });
    }
  }

  /// Fetch weather data from API
  Future<void> _fetchWeather() async {
    final index = _indexController.text.trim();

    if (index.isEmpty) {
      _showError('Please enter a student index number');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final weatherData = await _weatherService.fetchWeatherForIndex(index);

      if (mounted) {
        setState(() {
          _weatherData = weatherData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = _getFriendlyErrorMessage(e.toString());
        });
      }
    }
  }

  /// Convert technical error messages to user-friendly ones
  String _getFriendlyErrorMessage(String error) {
    if (error.contains('Invalid index format')) {
      return 'Please enter a valid student index with at least 4 digits';
    } else if (error.contains('No internet connection')) {
      return 'No internet connection. Please check your network and try again.';
    } else if (error.contains('SocketException') || error.contains('TimeoutException')) {
      return 'Unable to connect to the weather service. Please check your internet connection.';
    } else if (error.contains('FormatException')) {
      return 'Received invalid data from the weather service. Please try again.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }

  /// Show error message in a snackbar
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personalized Weather Dashboard'),
        centerTitle: true,
        elevation: 2,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.shade100,
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IndexInputWidget(
                  controller: _indexController,
                  onFetchWeather: _fetchWeather,
                  isLoading: _isLoading,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorCard(),
                ],
                if (_weatherData != null) ...[
                  const SizedBox(height: 16),
                  WeatherDisplayWidget(weatherData: _weatherData!),
                ],
                if (_weatherData == null && _errorMessage == null && !_isLoading) ...[
                  const SizedBox(height: 32),
                  _buildWelcomeMessage(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      color: Colors.red.shade50,
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _errorMessage!,
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeMessage() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              Icons.wb_sunny_outlined,
              size: 64,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Weather Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your student index number above and tap "Fetch Weather" to get started.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
