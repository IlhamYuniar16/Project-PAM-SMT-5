// lib/feature/insightmind/data/models/history_item.dart
class HistoryItem {
  final String id;
  final DateTime timestamp;
  final Map<String, dynamic> sensorData;
  final Map<String, dynamic> aiResult;
  final String? notes;

  HistoryItem({
    required this.id,
    required this.timestamp,
    required this.sensorData,
    required this.aiResult,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'sensorData': sensorData,
      'aiResult': aiResult,
      'notes': notes,
    };
  }

  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      sensorData: Map<String, dynamic>.from(json['sensorData']),
      aiResult: Map<String, dynamic>.from(json['aiResult']),
      notes: json['notes'],
    );
  }
}