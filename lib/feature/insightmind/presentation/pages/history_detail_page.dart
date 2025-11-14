import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/mental_result.dart';

const Color kMainBackgroundColor = Color(0xFF9B9AFF);

class HistoryDetailPage extends StatelessWidget {
  final String title;
  final MentalResult result;

  const HistoryDetailPage({
    super.key,
    required this.title,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.graphic_eq, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detail Hasil',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Risk Level: ${result.riskLevel}',
                  style: GoogleFonts.poppins(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurple[600],
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Score: ${result.score}',
                  style: GoogleFonts.poppins(fontSize: 18.sp),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Deskripsi:',
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  result.description,
                  style: GoogleFonts.poppins(fontSize: 16.sp, height: 1.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
