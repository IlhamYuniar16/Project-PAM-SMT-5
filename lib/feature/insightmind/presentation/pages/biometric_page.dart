import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/history_detail_page.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/providers/ai_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_project_pam/feature/insightmind/data/models/feature_vector.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/sensors_provider.dart';
import '../providers/ppg_provider.dart';
import '../providers/score_provider.dart';
import 'ai_result_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/history_providers.dart';

const Color kPrimaryColor = Color(0xFF6C63FF);
const Color kSecondaryColor = Color(0xFFF5F5FF);
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kWarningColor = Color(0xFFFF9800);
const Color kDangerColor = Color(0xFFF44336);
const Color kBackgroundColor = Color(0xFFF8F9FF);

class BiometricPage extends ConsumerWidget {
  const BiometricPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accelFeat = ref.watch(accelFeatureProvider);
    final score = ref.watch(scoreProvider);
    final ppg = ref.watch(ppgProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ppg.errorMessage != null && ppg.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ppg.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Hapus',
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
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Analisis Biometrik & AI",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: kMainBackgroundColor,
        foregroundColor: Colors.white,
        elevation: 0,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(20.r),
        //     bottomRight: Radius.circular(20.r),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            SizedBox(height: 10.h),

            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: kPrimaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.monitor_heart,
                              color: kPrimaryColor,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Monitor PPG",
                                style: GoogleFonts.poppins(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Deteksi denyut nadi berbasis kamera",
                                style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (ppg.capturing)
                        Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: IconButton(
                            icon: Icon(
                              ppg.isFrontCamera
                                  ? Icons.camera_rear
                                  : Icons.camera_front,
                              color: Colors.white,
                              size: 20.sp,
                            ),
                            onPressed: () {
                              ref.read(ppgProvider.notifier).switchCamera();
                            },
                            tooltip: ppg.isFrontCamera 
                                ? "Ganti ke Kamera Belakang" 
                                : "Ganti ke Kamera Depan",
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  if (ppg.errorMessage != null && ppg.errorMessage!.isNotEmpty)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: kDangerColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: kDangerColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: kDangerColor, size: 22.sp),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Kesalahan Kamera: ${ppg.errorMessage}",
                              style: GoogleFonts.poppins(
                                color: kDangerColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  SizedBox(height: 20.h),

                  Container(
                    height: 200.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: ppg.capturing && ppg.controller != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Stack(
                              children: [
                                CameraPreview(ppg.controller!),
                                Positioned(
                                  top: 12.w,
                                  right: 12.w,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: Colors.green,
                                          size: 8.sp,
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          ppg.isFrontCamera ? "KAMERA DEPAN" : "KAMERA BELAKANG",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 48.sp,
                                  color: Colors.grey[400],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "Pratinjau Kamera",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[500],
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Tekan 'Mulai Pengambilan' untuk memulai",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey[400],
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetricTile(
                              icon: Icons.timeline,
                              title: "Rata-rata PPG",
                              value: "${ppg.mean.toStringAsFixed(4)}",
                              color: kPrimaryColor,
                            ),
                            _buildMetricTile(
                              icon: Icons.auto_graph,
                              title: "Varians PPG",
                              value: "${ppg.variance.toStringAsFixed(4)}",
                              color: kWarningColor,
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildMetricTile(
                              icon: Icons.insights,
                              title: "Sampel",
                              value: "${ppg.samples.length}",
                              color: kSuccessColor,
                              suffix: "/300",
                            ),
                            // _buildMetricTile(
                            //   icon: Icons.speed,
                            //   title: "Status",
                            //   value: ppg.capturing ? "Aktif" : "Siap",
                            //   color: ppg.capturing ? Colors.green : Colors.grey,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            final notifier = ref.read(ppgProvider.notifier);
                            if (ppg.capturing) {
                              notifier.stopCapture();
                            } else {
                              notifier.startCapture();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ppg.capturing ? Colors.red : kMainBackgroundColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 2,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                ppg.capturing ? Icons.stop_circle : Icons.play_circle_fill,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                ppg.capturing ? "Hentikan Pengambilan" : "Mulai Pengambilan",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (ppg.samples.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(left: 12.w),
                          child: SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(ppgProvider.notifier).clearSamples();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.red,
                                padding: EdgeInsets.symmetric(horizontal: 16.w),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side: BorderSide(color: Colors.red),
                                ),
                              ),
                              child: Icon(Icons.delete_outline, size: 22.sp),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),

            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.deepPurple,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Analisis AI",
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Hasilkan prediksi kesehatan mental",
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAIMetric(
                          title: "Data Aktivitas",
                          mean: accelFeat.mean,
                          variance: accelFeat.variance,
                          color: Colors.blue,
                        ),
                        Container(
                          height: 40.h,
                          width: 1,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 15,),
                        _buildAIMetric(
                          title: "Data PPG",
                          mean: ppg.mean,
                          variance: ppg.variance,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  ElevatedButton(
                    onPressed: () async {
                      if (ppg.samples.length < 30) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Harap kumpulkan minimal 30 sampel PPG terlebih dahulu"),
                            backgroundColor: Colors.orange,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        );
                        return;
                      }

                      final random = Random();
                      final variedScore = score + (random.nextDouble() * 40 - 20).round();
                      final finalScore = variedScore.clamp(0, 100).toDouble();
                      final variedPPGMean = ppg.mean + (random.nextDouble() * 20 - 10);
                      final variedPPGVar = ppg.variance + (random.nextDouble() * 0.5 - 0.25);
                      final variedActivityMean = accelFeat.mean + (random.nextDouble() * 0.5 - 0.25);
                      final variedActivityVar = accelFeat.variance + (random.nextDouble() * 0.2 - 0.1);

                      final fv = FeatureVector(
                        screeningScore: finalScore,
                        activityMean: variedActivityMean.clamp(0.0, 5.0),
                        activityVar: variedActivityVar.clamp(0.0, 2.0),
                        ppgMean: variedPPGMean.clamp(0.0, 255.0),
                        ppgVar: variedPPGVar.clamp(0.0, 50.0),
                      );

                      final aiPredictor = ref.read(aiPredictorProvider);
                      final aiResult = aiPredictor.predict(fv);

                      await ref.read(aiHistoryProvider.notifier).addAIResult(
                        score: aiResult['score'] ?? 0,
                        riskLevel: aiResult['riskLevel'] ?? 'Sedang',
                        description: aiResult['description'] ?? 'Hasil Penilaian AI',
                        ppgMean: fv.ppgMean,
                        ppgVariance: fv.ppgVar,
                        activityMean: fv.activityMean,
                        activityVariance: fv.activityVar,
                        screeningScore: fv.screeningScore,
                        aiConfidence: (aiResult['confidence'] as num?)?.toDouble() ?? 0.85,
                        recommendations: List<String>.from(
                          aiResult['recommendations'] ?? [],
                        ),
                        vitalSigns: Map<String, dynamic>.from(
                          aiResult['vitalSigns'] ?? {},
                        ),
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AIResultPage(fv: fv, aiResult: aiResult),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMainBackgroundColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 3,
                      minimumSize: Size(double.infinity, 56.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.psychology, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          "Hasilkan Prediksi AI",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 12.h),
                  
                  Text(
                    "Catatan: AI akan menganalisis data biometrik Anda untuk memberikan penilaian kesehatan mental",
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    String suffix = '',
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16.sp, color: color),
                SizedBox(width: 6.w),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (suffix.isNotEmpty)
                    TextSpan(
                      text: suffix,
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIMetric({
    required String title,
    required double mean,
    required double variance,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Rata-rata",
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      mean.toStringAsFixed(4),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Varians",
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      variance.toStringAsFixed(4),
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}