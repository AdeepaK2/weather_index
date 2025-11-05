class WeatherData {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String timestamp;
  final String requestUrl;
  final double latitude;
  final double longitude;
  final bool isCached;

  WeatherData({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.timestamp,
    required this.requestUrl,
    required this.latitude,
    required this.longitude,
    this.isCached = false,
  });

  // Create from JSON response from API (OpenWeatherMap format)
  factory WeatherData.fromJson(
    Map<String, dynamic> json,
    String url,
    double lat,
    double lon,
  ) {
    final main = json['main'] as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>;
    final weather = (json['weather'] as List<dynamic>)[0] as Map<String, dynamic>;

    return WeatherData(
      temperature: (main['temp'] as num).toDouble(),
      windSpeed: (wind['speed'] as num).toDouble() * 3.6, // Convert m/s to km/h
      weatherCode: weather['id'] as int,
      timestamp: DateTime.now().toIso8601String(),
      requestUrl: url,
      latitude: lat,
      longitude: lon,
      isCached: false,
    );
  }

  // Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'windSpeed': windSpeed,
      'weatherCode': weatherCode,
      'timestamp': timestamp,
      'requestUrl': requestUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create from cached JSON
  factory WeatherData.fromCache(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['temperature'] as double,
      windSpeed: json['windSpeed'] as double,
      weatherCode: json['weatherCode'] as int,
      timestamp: json['timestamp'] as String,
      requestUrl: json['requestUrl'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      isCached: true,
    );
  }

  // Create a copy with isCached flag set
  WeatherData copyWith({bool? isCached}) {
    return WeatherData(
      temperature: temperature,
      windSpeed: windSpeed,
      weatherCode: weatherCode,
      timestamp: timestamp,
      requestUrl: requestUrl,
      latitude: latitude,
      longitude: longitude,
      isCached: isCached ?? this.isCached,
    );
  }
}
