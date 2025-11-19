import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/history_repository.dart';
import '../../data/local/screening_record.dart';
import '../../domain/entities/mental_result.dart';

class HistoryNotifier extends StateNotifier<List<MentalResult>> {
  final HistoryRepository _repo;
  final String _testType; 

  HistoryNotifier(this._repo, this._testType) : super([]) {
    _loadFromRepo();
  }

  Future<void> _loadFromRepo() async {
    try {
      final records = await _repo.getAll();
      final filteredRecords = records.where((record) {
        return record.testType == _testType;
      }).toList();
      
      state = filteredRecords
          .map(
            (r) => MentalResult(
              score: r.score,
              riskLevel: r.riskLevel,
              description: r.note ?? r.riskLevel,
              timestamp: r.timestamp,
              testType: _testType,
              id: r.id,
            ),
          )
          .toList();
    } catch (_) {
      state = [];
    }
  }

  Future<void> addResultToHistory(MentalResult result) async {
    await _repo.addRecord(
      score: result.score,
      riskLevel: result.riskLevel,
      note: result.description,
      testType: _testType,
    );
    await _loadFromRepo();
  }

  Future<void> removeResultFromHistory(MentalResult result) async {
    if (result.id != null) {
      await _repo.deleteById(result.id!);
    } else {
      final records = await _repo.getAll();
      try {
        final match = records.firstWhere(
          (r) => r.score == result.score && 
                 r.timestamp == result.timestamp &&
                 r.testType == _testType, 
        );
        await _repo.deleteById(match.id);
      } catch (_) {

      }
    }

    await _loadFromRepo();
  }

  Future<void> clearHistory() async {
    final records = await _repo.getAll();

    for (final record in records) {
      if (record.testType == _testType) {
        await _repo.deleteById(record.id);
      }
    }
    
    await _loadFromRepo();
  }
}

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

final psikologiHistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<MentalResult>>((ref) {
      final repo = ref.watch(historyRepositoryProvider);
      return HistoryNotifier(repo, 'psikologi');
    });

final mentalHistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<MentalResult>>((ref) {
      final repo = ref.watch(historyRepositoryProvider);
      return HistoryNotifier(repo, 'mental');
    });

final historyListProvider = FutureProvider<List<ScreeningRecord>>((ref) async {
 final repo = ref.watch(historyRepositoryProvider);
 return repo.getAll();
});