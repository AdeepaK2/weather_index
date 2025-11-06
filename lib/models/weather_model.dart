class WeatherModel {
  final double temperature;
  final double windSpeed;
  final int weatherCode;
  final String lastUpdated;
  final String requestUrl;

  WeatherModel({
    required this.temperature,
    required this.windSpeed,
    required this.weatherCode,
    required this.lastUpdated,
    required this.requestUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'windSpeed': windSpeed,
      'weatherCode': weatherCode,
      'lastUpdated': lastUpdated,
      'requestUrl': requestUrl,
    };
  }

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      temperature: json['temperature'] as double,
      windSpeed: json['windSpeed'] as double,
      weatherCode: json['weatherCode'] as int,
      lastUpdated: json['lastUpdated'] as String,
      requestUrl: json['requestUrl'] as String,
    );
  }
}
