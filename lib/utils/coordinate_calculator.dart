class CoordinateCalculator {
  static Map<String, double>? calculateFromIndex(String index) {
    if (index.length < 4) {
      return null;
    }

    // Extract first 2 and next 2 digits
    final digits = index.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 4) {
      return null;
    }

    final firstTwo = int.parse(digits.substring(0, 2));
    final nextTwo = int.parse(digits.substring(2, 4));

    final latitude = 5.0 + (firstTwo / 10.0);
    final longitude = 79.0 + (nextTwo / 10.0);

    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
