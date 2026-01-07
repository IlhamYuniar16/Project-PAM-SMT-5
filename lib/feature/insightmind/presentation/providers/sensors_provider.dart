// sensors_provider.dart - PROVIDER UNTUK ACCELEROMETER
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccelFeature {
  final double mean;
  final double variance;

  AccelFeature({required this.mean, required this.variance});
}

// Provider untuk accelerometer features
final accelFeatureProvider = StateProvider<AccelFeature>((ref) {
  return AccelFeature(mean: 0.0, variance: 0.0);
});