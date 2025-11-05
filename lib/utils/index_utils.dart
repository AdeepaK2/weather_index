class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});
}

class IndexUtils {
  /// Derives coordinates from a student index number
  /// Example: 194174B -> lat: 6.9, lon: 80.7
  static Coordinates deriveCoordinates(String index) {
    // Remove any letters and whitespace
    final numericPart = index.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericPart.length < 4) {
      throw ArgumentError(
        'Index must contain at least 4 digits. Got: $index',
      );
    }

    // Extract first two and next two digits
    final firstTwo = int.parse(numericPart.substring(0, 2));
    final nextTwo = int.parse(numericPart.substring(2, 4));

    // Calculate coordinates according to the formula
    final latitude = 5 + (firstTwo / 10.0);
    final longitude = 79 + (nextTwo / 10.0);

    return Coordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Formats a double to 2 decimal places
  static String formatCoordinate(double value) {
    return value.toStringAsFixed(2);
  }

  /// Validates if the index format is correct
  static bool isValidIndex(String index) {
    // Should contain at least 4 digits
    final numericPart = index.replaceAll(RegExp(r'[^0-9]'), '');
    return numericPart.length >= 4;
  }
}
