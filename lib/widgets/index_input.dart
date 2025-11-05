import 'package:flutter/material.dart';
import '../utils/index_utils.dart';

class IndexInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFetchWeather;
  final bool isLoading;

  const IndexInputWidget({
    super.key,
    required this.controller,
    required this.onFetchWeather,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Student Index Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'e.g., 224110P',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.characters,
              enabled: !isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isLoading ? null : onFetchWeather,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(isLoading ? 'Fetching...' : 'Fetch Weather'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildCoordinatesDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildCoordinatesDisplay() {
    if (controller.text.isEmpty ||
        !IndexUtils.isValidIndex(controller.text)) {
      return const SizedBox.shrink();
    }

    try {
      final coordinates = IndexUtils.deriveCoordinates(controller.text);
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            const Text(
              'Derived Coordinates',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Lat: ${IndexUtils.formatCoordinate(coordinates.latitude)}, '
              'Lon: ${IndexUtils.formatCoordinate(coordinates.longitude)}',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
