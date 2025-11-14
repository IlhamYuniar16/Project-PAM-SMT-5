class CalculateRiskLevel {
  String execute(int score) {
    String level;
    if (score < 10) {
      level = "Rendah";
    } else if (score < 20) {
      level = "Sedang";
    } else {
      level = "Tinggi";
    }
    return level;
  }
}
