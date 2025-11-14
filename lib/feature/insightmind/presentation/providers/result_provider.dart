import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResultNotifier extends StateNotifier<List<int>> {
  ResultNotifier() : super([]);

  void saveResult(int score) {
    state = [...state, score];
  }

  void clear() {
    state = [];
  }
}

final resultProvider =
    StateNotifierProvider<ResultNotifier, List<int>>((ref) {
  return ResultNotifier();
});
