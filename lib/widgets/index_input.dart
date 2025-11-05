import 'package:flutter/material.dart';
import '../utils/index_utils.dart';

class IndexInputWidget extends StatefulWidget {
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
  State<IndexInputWidget> createState() => _IndexInputWidgetState();
}

class _IndexInputWidgetState extends State<IndexInputWidget> {
  @override
  void initState() {
    super.initState();
    // Listen to text changes to update coordinates
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    // Trigger rebuild when text changes
    if (mounted) {
      setState(() {});
    }
  }

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
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: 'e.g., 224110P',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
              textCapitalization: TextCapitalization.characters,
              enabled: !widget.isLoading,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: widget.isLoading ? null : widget.onFetchWeather,
              icon: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.cloud_download),
              label: Text(widget.isLoading ? 'Fetching...' : 'Fetch Weather'),
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
    if (widget.controller.text.isEmpty ||
        !IndexUtils.isValidIndex(widget.controller.text)) {
      return const SizedBox.shrink();
    }

    try {
      final coordinates = IndexUtils.deriveCoordinates(widget.controller.text);
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
