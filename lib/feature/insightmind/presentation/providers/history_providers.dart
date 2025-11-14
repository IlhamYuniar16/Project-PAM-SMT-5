import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mental_result.dart';
import '../../data/local/history_repository.dart';
import '../../data/local/screening_record.dart';
// screening_record model imported in repository; not needed directly here

/// HistoryNotifier now persists to Hive via HistoryRepository.
class HistoryNotifier extends StateNotifier<List<MentalResult>> {
  final HistoryRepository _repo;
  final String _testType; // 'psikologi' or 'mental'

  HistoryNotifier(this._repo, this._testType) : super([]) {
    _loadFromRepo();
  }

  Future<void> _loadFromRepo() async {
    try {
      final records = await _repo.getAll();
      state = records
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
    // persist
    await _repo.addRecord(
      score: result.score,
      riskLevel: result.riskLevel,
      note: result.description,
    );
    await _loadFromRepo();
  }

  Future<void> removeResultFromHistory(MentalResult result) async {
    if (result.id != null) {
      await _repo.deleteById(result.id!);
    } else {
      // fallback: try to find matching record by timestamp+score
      final records = await _repo.getAll();
      try {
        final match = records.firstWhere(
          (r) => r.score == result.score && r.timestamp == result.timestamp,
        );
        await _repo.deleteById(match.id);
      } catch (_) {
        // nothing
      }
    }

    await _loadFromRepo();
  }

  Future<void> clearHistory() async {
    await _repo.clearAll();
    state = [];
  }
}

final psikologiHistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<MentalResult>>((ref) {
      final repo = HistoryRepository();
      return HistoryNotifier(repo, 'psikologi');
    });

final mentalHistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<MentalResult>>((ref) {
      final repo = HistoryRepository();
      return HistoryNotifier(repo, 'mental');
    });
final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
 return HistoryRepository();
});

final historyListProvider = FutureProvider<List<ScreeningRecord>>((ref) async {
 final repo = ref.watch(historyRepositoryProvider);
 return repo.getAll();
});