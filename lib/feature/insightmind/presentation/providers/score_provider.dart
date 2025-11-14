import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/score_repository.dart';
import '../../domain/usecases/calculate_risk_level.dart';
import '../../domain/entities/mental_result.dart';

final answersProvider = StateProvider<List<int>>((ref) => []);

final scoreRepositoryProvider = Provider((ref) => ScoreRepository());
final calculateRiskProvider = Provider((ref) => CalculateRiskLevel());

final scoreProvider = Provider<int>((ref) {
  final answers = ref.watch(answersProvider);
  final repo = ref.watch(scoreRepositoryProvider);
  return repo.calculateScore(answers);
});

final resultProvider = Provider<MentalResult>((ref) {
  final score = ref.watch(scoreProvider);

  final usecase = ref.watch(calculateRiskProvider);

  final String riskLevel = usecase.execute(score);

  String generatedDescription;
  switch (riskLevel) {
    case 'Rendah':
      generatedDescription =
          'Level risiko Anda rendah. Pertahankan kebiasaan baik Anda!';
      break;
    case 'Sedang':
      generatedDescription =
          'Level risiko Anda sedang. Coba untuk bercerita dengan teman.';
      break;
    case 'Tinggi':
      generatedDescription =
          'Level risiko Anda tinggi. Mohon pertimbangkan konsultasi profesional.';
      break;
    default:
      generatedDescription = 'Deskripsi tidak tersedia.';
  }

  return MentalResult(
    score: score,
    riskLevel: riskLevel,
    description: generatedDescription,
    timestamp: DateTime.now(),
    testType: 'psikologi',
  );
});
