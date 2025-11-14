import '../../domain/entities/question_mental.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionnaireStateMental {
 final Map<String, int> answers;
 const QuestionnaireStateMental({this.answers = const {}});

 QuestionnaireStateMental copyWith({Map<String, int>? answers}) {
 return QuestionnaireStateMental(answers: answers ?? this.answers);
 }

 bool get isComplete => answers.length >= defaultQuestionsMental.length;
 int get totalScore => answers.values.fold(0, (a, b) => a + b);
}

class QuestionnaireNotifierMental extends StateNotifier<QuestionnaireStateMental> {
 QuestionnaireNotifierMental() : super(const QuestionnaireStateMental());

 void selectAnswer({required String questionId, required int score}) {
  final newMap = Map<String, int>.from(state.answers);
  newMap[questionId] = score;
  state = state.copyWith(answers: newMap); }

 void reset() {
 state = const QuestionnaireStateMental();
 }
}

final questionsProviderMental = Provider<List<QuestionMental>>((ref) {
 return defaultQuestionsMental;
});

final questionnaireProviderMental =
  StateNotifierProvider<QuestionnaireNotifierMental, QuestionnaireStateMental>((ref) {
 return QuestionnaireNotifierMental();
});
