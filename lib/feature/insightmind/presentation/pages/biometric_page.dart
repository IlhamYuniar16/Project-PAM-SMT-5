// WEEK6 + WEEK7: Integrasi Sensor → FeatureVector → AI
import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/providers/ai_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';

import 'package:flutter_project_pam/feature/insightmind/data/models/feature_vector.dart';
import '../providers/sensors_provider.dart'; // Import sensors provider
import '../providers/ppg_provider.dart';
import '../providers/score_provider.dart';
import 'ai_result_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/history_providers.dart';
import '../../domain/entities/ai_result.dart';

class BiometricPage extends ConsumerWidget {
  const BiometricPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sekarang provider ini akan tersedia setelah membuat sensors_provider.dart
    final accelFeat = ref.watch(accelFeatureProvider);
    final score = ref.watch(scoreProvider);
    final ppg = ref.watch(ppgProvider);

    // Error handling dengan SnackBar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ppg.errorMessage != null && ppg.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ppg.errorMessage!),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Clear',
              textColor: Colors.white,
              onPressed: () {
                ref.read(ppgProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("Sensor & AI", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF8A84FF),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ================= ACCELEROMETER CARD =================
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Fitur Accelerometer",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text("Mean: ${accelFeat.mean.toStringAsFixed(4)}"),
                  Text("Variance: ${accelFeat.variance.toStringAsFixed(4)}"),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ================= CAMERA PPG CARD =================
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Fitur PPG via Kamera",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // TOMBOL SWITCH CAMERA
                      if (ppg.capturing)
                        IconButton(
                          icon: Icon(
                            ppg.isFrontCamera
                                ? Icons.camera_rear
                                : Icons.camera_front,
                            color: Colors.white,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: Color(0xFF8A84FF),
                          ),
                          onPressed: () {
                            ref.read(ppgProvider.notifier).switchCamera();
                          },
                          tooltip: ppg.isFrontCamera
                              ? "Switch to Back Camera"
                              : "Switch to Front Camera",
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ERROR INDICATOR
                  if (ppg.errorMessage != null && ppg.errorMessage!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Camera Error",
                              style: TextStyle(
                                color: Colors.red.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 12),

                  // 🔥 CAMERA PREVIEW
                  if (ppg.capturing && ppg.controller != null)
                    Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: SizedBox(
                            width: double.infinity,
                            height: 350.h,
                            child: Stack(
                              children: [
                                CameraPreview(ppg.controller!),

                                // OVERLAY UNTUK INDIKATOR KAMERA
                                Positioned(
                                  top: 12,
                                  right: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      ppg.isFrontCamera ? "FRONT" : "BACK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                // LIVE INDICATOR
                                Positioned(
                                  bottom: 12,
                                  left: 12,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade800,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          size: 8,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          "LIVE",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // INDIKATOR TULISAN
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            ppg.isFrontCamera
                                ? "📱 Menggunakan Kamera Depan"
                                : "📱 Menggunakan Kamera Belakang",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Container(
                      height: 350.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ppg.errorMessage != null
                                ? Icons
                                      .videocam_off // Icon yang valid
                                : Icons.camera_alt,
                            size: 48,
                            color: ppg.errorMessage != null
                                ? Colors.red
                                : Colors.grey,
                          ),
                          SizedBox(height: 12),
                          Text(
                            ppg.errorMessage != null
                                ? "Camera Error"
                                : "Kamera siap digunakan",
                            style: TextStyle(
                              color: ppg.errorMessage != null
                                  ? Colors.red
                                  : Colors.black54,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            ppg.errorMessage != null
                                ? "Tap start to retry"
                                : "Default: Kamera Belakang",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),

                  // CAMERA INFO
                  Row(
                    children: [
                      Icon(
                        ppg.isFrontCamera
                            ? Icons.camera_front
                            : Icons.camera_rear,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Camera: ${ppg.isFrontCamera ? "Front" : "Back"}",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        "Samples: ${ppg.samples.length}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Mean Y: ${ppg.mean.toStringAsFixed(6)}",
                              style: TextStyle(fontSize: 12),
                            ),
                            Text(
                              "Variance Y: ${ppg.variance.toStringAsFixed(6)}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      if (ppg.samples.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF8A84FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xFF8A84FF).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            "${ppg.samples.length}/300",
                            style: TextStyle(
                              color: Color(0xFF8A84FF),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // TOMBOL START/STOP
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            final notifier = ref.read(ppgProvider.notifier);
                            if (ppg.capturing) {
                              notifier.stopCapture();
                            } else {
                              notifier.startCapture();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Color(0xFF8A84FF),
                            ),
                          ),
                          icon: Icon(
                            ppg.capturing ? Icons.stop : Icons.play_arrow,
                          ),
                          label: Text(
                            ppg.capturing ? "Stop Capture" : "Start Capture",
                          ),
                        ),
                      ),

                      // TOMBOL CLEAR DATA
                      if (ppg.samples.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () {
                              ref.read(ppgProvider.notifier).clearSamples();
                            },
                            tooltip: "Clear samples data",
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ================= AI PREDICTION =================
          FilledButton.icon(
            icon: const Icon(Icons.insights),
            label: const Text("Hitung Prediksi AI"),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF8A84FF)),
            ),
            // Di dalam onPressed untuk "Hitung Prediksi AI":
            onPressed: () async {
              if (ppg.samples.length < 30) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Ambil minimal 30 sampel PPG dahulu"),
                  ),
                );
                return;
              }

              final fv = FeatureVector(
                screeningScore: score.toDouble(),
                activityMean: accelFeat.mean,
                activityVar: accelFeat.variance,
                ppgMean: ppg.mean,
                ppgVar: ppg.variance,
              );

              // Panggil AI predictor
              final aiPredictor = ref.read(aiPredictorProvider);
              final aiResult = aiPredictor.predict(fv);

              // Save ke history
              await ref
                  .read(aiHistoryProvider.notifier)
                  .addAIResult(
                    score: aiResult['score'] ?? 0,
                    riskLevel: aiResult['riskLevel'] ?? 'Medium',
                    description:
                        aiResult['description'] ?? 'AI Assessment Result',
                    ppgMean: ppg.mean,
                    ppgVariance: ppg.variance,
                    activityMean: accelFeat.mean,
                    activityVariance: accelFeat.variance,
                    screeningScore: score.toDouble(),
                    aiConfidence: aiResult['confidence'] ?? 0.85,
                    recommendations: List<String>.from(
                      aiResult['recommendations'] ?? [],
                    ),
                    vitalSigns: Map<String, dynamic>.from(
                      aiResult['vitalSigns'] ?? {},
                    ),
                  );

              // Navigate ke result page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AIResultPage(fv: fv)),
              );
            },
          ),
        ],
      ),
    );
  }
}
