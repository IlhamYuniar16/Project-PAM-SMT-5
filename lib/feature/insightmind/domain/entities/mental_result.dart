class MentalResult {
  final String? id;
  final int score;
  final String riskLevel;
  final String description;
  final DateTime timestamp;
  final String testType; // 'psikologi' or 'mental'

  MentalResult({
    this.id,
    required this.score,
    required this.riskLevel,
    required this.description,
    required this.timestamp,
    required this.testType,
  });
}
