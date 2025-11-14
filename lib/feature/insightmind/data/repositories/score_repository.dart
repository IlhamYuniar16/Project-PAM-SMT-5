class ScoreRepository {
  int calculateScore(List<int> answers) {
    return answers.fold(0, (a, b) => a + b);
  }
}
