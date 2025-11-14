import 'package:hive/hive.dart';
part 'screening_record.g.dart';

@HiveType(typeId: 1) 
class ScreeningRecord extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final int score;

  @HiveField(3)
  final String riskLevel;

  @HiveField(4)
  final String? note;

  ScreeningRecord({
    required this.id,
    required this.timestamp,
    required this.score,
    required this.riskLevel,
    this.note,
  });

  @override
  String toString() {
    return 'ScreeningRecord(id: $id, score: $score, riskLevel: $riskLevel, date: $timestamp, note: $note)';
  }
}
