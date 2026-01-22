import 'package:hive/hive.dart';
part 'penilaian.g.dart';

@HiveType(typeId: 2)
class Penilaian extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final int rating;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final String feedback;

  Penilaian({
    required this.id,
    required this.timestamp,
    required this.rating,
    required this.category,
    required this.feedback,
  });

  @override
  String toString() {
    return 'Penilaian(id: $id, rating: $rating, category: $category, date: $timestamp, feedback: $feedback)';
  }
}
