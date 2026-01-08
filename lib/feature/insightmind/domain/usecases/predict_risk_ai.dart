// WEEK7: AI Predictor dengan logika yang seimbang - BAHASA INDONESIA
import 'dart:math';

import 'package:flutter_project_pam/feature/insightmind/data/models/feature_vector.dart';

class PredictRiskAI {
  Map<String, dynamic> predict(FeatureVector fv) {
    // ========== 1. NORMALISASI FITUR ==========
    // Skor screening (0-100) → normalisasi ke 0-1
    final normalizedScore = (fv.screeningScore / 100.0).clamp(0.0, 1.0);
    
    // PPG Mean (biasanya 0-255) → normalisasi ke 0-1
    final normalizedPPGMean = (fv.ppgMean / 255.0).clamp(0.0, 1.0);
    
    // PPG Variance (biasanya 0-50) → normalisasi ke 0-1, lebih rendah lebih baik
    final normalizedPPGVar = (fv.ppgVar / 50.0).clamp(0.0, 1.0);
    final ppgStability = 1.0 - normalizedPPGVar; // 1 = sangat stabil
    
    // Activity Mean (biasanya 0-5) → normalisasi ke 0-1
    final normalizedActivityMean = (fv.activityMean / 5.0).clamp(0.0, 1.0);
    
    // Activity Variance (biasanya 0-2) → normalisasi ke 0-1
    final normalizedActivityVar = (fv.activityVar / 2.0).clamp(0.0, 1.0);
    final activityConsistency = 1.0 - normalizedActivityVar; // 1 = sangat konsisten
    
    // ========== 2. HITUNG SUB-SKOR ==========
    
    // A. Sub-skor Screening (40%)
    final screeningSubScore = normalizedScore * 40;
    
    // B. Sub-skor Kesehatan PPG (30%)
    // Kesehatan PPG = 70% stabilitas + 30% nilai mean
    final ppgHealthScore = (ppgStability * 0.7 + normalizedPPGMean * 0.3) * 30;
    
    // C. Sub-skor Kesehatan Aktivitas (30%)
    // Kesehatan aktivitas = 50% mean + 50% konsistensi
    final activityHealthScore = (normalizedActivityMean * 0.5 + activityConsistency * 0.5) * 30;
    
    // ========== 3. HITUNG TOTAL SKOR KOMPOSIT ==========
    double compositeScore = screeningSubScore + ppgHealthScore + activityHealthScore;
    
    // Tambahkan variasi kecil (±5 poin) untuk simulasi data real
    final random = Random();
    compositeScore += (random.nextDouble() * 10 - 5); // -5 to +5
    compositeScore = compositeScore.clamp(0.0, 100.0);
    
    // ========== 4. TENTUKAN LEVEL RISIKO ==========
    String riskLevel;
    String riskDescription;
    
    if (compositeScore >= 70) {
      riskLevel = 'Rendah';
      riskDescription = 'Kesejahteraan mental baik';
    } else if (compositeScore >= 45) {
      riskLevel = 'Sedang';
      riskDescription = 'Terdeteksi stres moderat';
    } else {
      riskLevel = 'Tinggi';
      riskDescription = 'Stres tinggi - direkomendasikan bantuan profesional';
    }
    
    // ========== 5. HITUNG KEPERCAYAAN AI ==========
    // Kepercayaan berdasarkan kualitas dan konsistensi data
    double aiConfidence = 0.85; // Baseline
    
    // Tambah kepercayaan jika data lengkap
    if (fv.screeningScore > 0) aiConfidence += 0.05;
    if (fv.ppgMean > 0 && fv.ppgVar > 0) aiConfidence += 0.05;
    if (fv.activityMean > 0 && fv.activityVar > 0) aiConfidence += 0.05;
    
    aiConfidence = aiConfidence.clamp(0.7, 0.95);
    
    // ========== 6. HASILKAN REKOMENDASI BERDASARKAN SKOR ==========
    final List<String> recommendations = [];
    
    if (compositeScore >= 70) {
      // Rekomendasi risiko rendah
      recommendations.addAll([
        'Lanjutkan kebiasaan gaya hidup sehat Anda',
        'Praktikkan meditasi mindfulness 10 menit setiap hari',
        'Jaga koneksi sosial secara teratur',
        'Dapatkan 7-8 jam tidur berkualitas setiap malam',
        'Pertimbangkan journaling untuk refleksi diri',
      ]);
    } else if (compositeScore >= 45) {
      // Rekomendasi risiko sedang
      recommendations.addAll([
        'Lakukan latihan pernapasan dalam setiap hari',
        'Ambil istirahat teratur saat bekerja (5 menit setiap jam)',
        'Batasi waktu layar sebelum tidur',
        'Lakukan aktivitas fisik 3 kali seminggu',
        'Hubungi teman atau keluarga setiap minggu',
      ]);
    } else {
      // Rekomendasi risiko tinggi
      recommendations.addAll([
        'Pertimbangkan konsultasi dengan profesional kesehatan mental',
        'Praktikkan teknik relaksasi harian',
        'Buat jadwal tidur yang konsisten',
        'Kurangi konsumsi kafein dan gula',
        'Bergabung dengan grup dukungan atau komunitas',
        'Ambil cuti jika stres kerja tinggi',
      ]);
    }
    
    // ========== 7. HASILKAN TANDA VITAL ==========
    // Fungsi helper untuk menentukan tinggi/rendah berdasarkan skor
    String getLevelFromScore(double score) {
      if (score >= 70) return 'Rendah';
      if (score >= 45) return 'Sedang';
      return 'Tinggi';
    }
    
    // Fungsi helper untuk menentukan kualitas berdasarkan skor
    String getQualityFromScore(double score) {
      if (score >= 70) return 'Baik';
      if (score >= 45) return 'Cukup';
      return 'Buruk';
    }
    
    final vitalSigns = {
      'level_stres': getLevelFromScore(compositeScore),
      'indeks_pemulihan': '${compositeScore.toInt()}%',
      'kelelahan_mental': getLevelFromScore(100 - compositeScore), // Kebalikan dari stres
      'stres_kardiovaskular': ppgStability > 0.7 ? 'Rendah' : (ppgStability > 0.4 ? 'Sedang' : 'Tinggi'),
      'aktivitas_fisik': normalizedActivityMean > 0.6 ? 'Tinggi' : (normalizedActivityMean > 0.3 ? 'Sedang' : 'Rendah'),
      'perkiraan_kualitas_tidur': getQualityFromScore(compositeScore),
      'keseimbangan_emosional': getQualityFromScore(compositeScore),
    };
    
    // ========== 8. HASILKAN DESKRIPSI DETAIL ==========
    final description = 'Hasil Analisis AI\n'
        '• Skor Komposit: ${compositeScore.toStringAsFixed(1)}/100\n'
        '• Level Risiko: $riskLevel\n'
        '• Skor Screening: ${(normalizedScore * 100).toInt()}%\n'
        '• Stabilitas PPG: ${(ppgStability * 100).toInt()}%\n'
        '• Level Aktivitas: ${(normalizedActivityMean * 100).toInt()}%\n'
        '• Tingkat Stres: ${vitalSigns['level_stres']}';
    
    // ========== 9. KEMBALIKAN HASIL ==========
    return {
      'score': compositeScore.round(),
      'riskLevel': riskLevel,
      'description': description,
      'confidence': aiConfidence,
      'recommendations': recommendations,
      'vitalSigns': vitalSigns,
      'compositeScore': compositeScore,
      'screeningScore': fv.screeningScore,
      'ppgMean': fv.ppgMean,
      'ppgVariance': fv.ppgVar,
      'activityMean': fv.activityMean,
      'activityVariance': fv.activityVar,
      'normalizedValues': {
        'screening': normalizedScore,
        'ppgStability': ppgStability,
        'activityLevel': normalizedActivityMean,
      }
    };
  }
}