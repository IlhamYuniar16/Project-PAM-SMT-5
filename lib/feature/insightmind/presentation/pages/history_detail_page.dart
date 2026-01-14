import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/chat_bot.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/screening_page_mental.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/screening_page_psikologi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/mental_result.dart';

const Color kMainBackgroundColor = Color(0xFF9B9AFF);
const Color kPrimaryColor = Color(0xFF6C63FF);
const Color kSecondaryColor = Color(0xFFF5F5FF);
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kWarningColor = Color(0xFFFF9800);
const Color kDangerColor = Color(0xFFF44336);
const Color kTextColor = Color(0xFF333333);
const Color kTextSecondaryColor = Color(0xFF666666);
const Color kCardGradientStart = Color(0xFF9B9AFF);
const Color kCardGradientEnd = Color(0xFF6C63FF);

class HistoryDetailPage extends StatelessWidget {
  final String title;
  final MentalResult result;

  const HistoryDetailPage({
    super.key,
    required this.title,
    required this.result,
  });

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
      case 'rendah':
        return kSuccessColor;
      case 'medium':
      case 'sedang':
        return kWarningColor;
      case 'high':
      case 'tinggi':
        return kDangerColor;
      default:
        return kPrimaryColor;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
      case 'rendah':
        return Icons.sentiment_very_satisfied;
      case 'medium':
      case 'sedang':
        return Icons.sentiment_neutral;
      case 'high':
      case 'tinggi':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.psychology;
    }
  }


  Widget _buildScoreCard(BuildContext context) {
    final score = result.score is int ? (result.score as int).toDouble() : 0.0;
    final percentage = (score / 100).clamp(0.0, 1.0);
    
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            kSecondaryColor,
          ],
        ),
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.15),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: _getRiskColor(result.riskLevel).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.assessment,
                  color: _getRiskColor(result.riskLevel),
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Detail Skor Mental',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Skor Anda',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: kTextSecondaryColor,
                    ),
                  ),
                  Text(
                    '${score.toInt()}/100',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: _getRiskColor(result.riskLevel),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Stack(
                children: [
                  Container(
                    height: 16.h,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  Container(
                    height: 16.h,
                    width: MediaQuery.of(context).size.width * 0.75 * percentage,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getRiskColor(result.riskLevel).withOpacity(0.8),
                          _getRiskColor(result.riskLevel),
                        ],
                        stops: const [0.0, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: _getRiskColor(result.riskLevel).withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rendah',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: kSuccessColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Sedang',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: kWarningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Tinggi',
                    style: GoogleFonts.poppins(
                      fontSize: 11.sp,
                      color: kDangerColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: 20.h),
          
          // Score Info Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(
                color: Colors.grey.shade200,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: kPrimaryColor,
                  size: 20.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Skor ini menunjukkan tingkat kesehatan mental Anda berdasarkan tes yang telah diselesaikan.',
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: kTextSecondaryColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Card Header
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getRiskColor(result.riskLevel).withOpacity(0.1),
                  _getRiskColor(result.riskLevel).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.r),
                topRight: Radius.circular(25.r),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: _getRiskColor(result.riskLevel),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.description,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analisis Hasil',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: kTextColor,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Pemahaman kondisi mental Anda',
                        style: GoogleFonts.poppins(
                          fontSize: 12.sp,
                          color: kTextSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Description Content
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: kTextColor,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 20.h),
                
                // Status Indicator
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getRiskColor(result.riskLevel).withOpacity(0.08),
                        _getRiskColor(result.riskLevel).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRiskIcon(result.riskLevel),
                        color: _getRiskColor(result.riskLevel),
                        size: 28.sp,
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Status: ${result.riskLevel.toUpperCase()}',
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: _getRiskColor(result.riskLevel),
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              _getRiskMessage(result.riskLevel),
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: kTextSecondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getRiskMessage(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
      case 'rendah':
        return 'Kondisi mental Anda baik, pertahankan pola hidup sehat';
      case 'medium':
      case 'sedang':
        return 'Perhatikan kondisi mental Anda, lakukan relaksasi';
      case 'high':
      case 'tinggi':
        return 'Disarankan untuk berkonsultasi dengan profesional';
      default:
        return 'Perlu evaluasi lebih lanjut';
    }
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Tindakan Selanjutnya',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (title.toLowerCase().contains('psikologi') || 
              title.toLowerCase().contains('psikologi')) {
            // Navigasi ke Tes Psikologi
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreeningPage(),
              ),
            );
          } else {
            // Navigasi ke Tes Mental
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreeningPageMental(),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 18.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 5,
          shadowColor: kPrimaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              title.toLowerCase().contains('psikologi') || 
              title.toLowerCase().contains('psikologis')
                ? 'Tes Ulang Psikologi'
                : title.toLowerCase().contains('mental')
                  ? 'Tes Ulang Mental'
                  : 'Tes Ulang',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    ),
  ],
),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatBot()));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: kTextSecondaryColor,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                side: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.help_outline, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(
                    'Butuh Bantuan?',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            // color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.sp),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: IconButton(
              icon: Icon(Icons.graphic_eq, color: Colors.white, size: 22.sp),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10.h),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildScoreCard(context),
                  SizedBox(height: 10.h),
                  _buildDescriptionCard(),
                  _buildActionButtons(context),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}