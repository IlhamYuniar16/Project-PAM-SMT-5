import 'package:flutter/foundation.dart';
import '../entities/mental_result.dart';

@immutable
class AIResult {
  final String? id;
  final int score;
  final String riskLevel;
  final String description;
  final DateTime timestamp;
  final String testType;
  
  final double ppgMean;
  final double ppgVariance;
  final double activityMean;
  final double activityVariance;
  final double screeningScore;
  final double aiConfidence;
  final List<String> recommendations;
  final Map<String, dynamic> vitalSigns;

  const AIResult({
    this.id,
    required this.score,
    required this.riskLevel,
    required this.description,
    required this.timestamp,
    required this.testType,
    required this.ppgMean,
    required this.ppgVariance,
    required this.activityMean,
    required this.activityVariance,
    required this.screeningScore,
    this.aiConfidence = 0.0,
    this.recommendations = const [],
    this.vitalSigns = const {},
  });

  MentalResult toMentalResult() {
    return MentalResult(
      id: id,
      score: score,
      riskLevel: riskLevel,
      description: description,
      timestamp: timestamp,
      testType: testType,
    );
  }
}
