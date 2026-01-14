// lib/features/insightmind/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/biometric_page.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/chat_bot.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/masalah_psikologi.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/masalah_mental.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/screening_page_mental.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/score_provider.dart';
import 'screening_page_psikologi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(answersProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF8A84FF),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/img/logonotext.png', width: 40.w),
                SizedBox(width: 10.w),
                Text(
                  'SoulScan',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatBot()));
            }, 
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF8A84FF)),
              elevation: MaterialStateProperty.all(0)
            ),
            icon: const Icon(Icons.auto_awesome, size: 30, color: Colors.white,),
            label: const Text("Bot SoulScan", style: TextStyle(color: Colors.white))
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFF8A84FF),
              child: Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat datang di SoulScan',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      width: 220.w,
                      child: Text(
                        'Yukk Jaga Kesehatan Mental dan Sikologi kalian',
                        textWidthBasis: TextWidthBasis.parent,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 600.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFC7C3FF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.h),
                            Text(
                              'Pelajari Masalanya Yuk',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MasalahPsikologi(),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                              Color(0xFFFFB7C5),
                                            ),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 0.w),
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10.r,
                                                ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.all(20.w),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/img/logoOtak.png',
                                                    width: 60.w,
                                                  ),
                                                  SizedBox(width: 20.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Masalah Psikologi',
                                                        style: GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                              0xFF8A84FF,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 7.h),
                                                      Container(
                                                        width: 200.w,
                                                        child: Text(
                                                          'Mari baca penyebab dari masalah psikologi sebelum terjadi',
                                                          style: GoogleFonts.poppins(
                                                            textStyle:
                                                                TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20.h),
                                Column(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const MasalahMental(),
                                          ),
                                        );
                                      },
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                              Color(0xFFA8E6CF),
                                            ),
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 0.w),
                                        ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  10.r,
                                                ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Padding(
                                              padding: EdgeInsets.all(20.w),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/img/logoMental.png',
                                                    width: 60.w,
                                                  ),
                                                  SizedBox(width: 20.w),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text('Masalah Mental', style: GoogleFonts.poppins(
                                                          textStyle: TextStyle(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Color(
                                                              0xFF8A84FF,
                                                            ),
                                                          ),
                                                        ),),
                                                      SizedBox(height: 10.h,),
                                                      Container(
                                                        width: 230.w,
                                                        child: Text(
                                                          'Mari baca penyebab dari masalah kesehatan mental sebelum terjadi', style: GoogleFonts.poppins(
                                                            textStyle:
                                                                TextStyle(
                                                                  fontSize:
                                                                      10.sp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Pilih Jenis Tes',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Column(
                              children: [
                                Container(
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/img/logoOtak.png',
                                          ),
                                          SizedBox(width: 20.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tes Psikologi',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF8A84FF),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Container(
                                                width: 210.w,
                                                child: Text(
                                                  'Telusuri suasana hatimu, tingkat stres, dan keseimbangan emosional.',
                                                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 10.sp)),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const ScreeningPage(),
                                                    ),
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                        Color(0xFFFFB7C5),
                                                      ),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                          horizontal: 30.w,
                                                          vertical: 2.h,
                                                        ),
                                                      ),
                                                ),
                                                child: Text('Mulai', style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/img/logoMental.png',
                                          ),
                                          SizedBox(width: 20.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tes Kesehatan Mental',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF8A84FF),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Container(
                                                width: 210.w,
                                                child: Text(
                                                  'Cek kondisi fisikmu seperti detak jantung, pola tidur, dan tingkat energi',
                                                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 10.sp)),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const ScreeningPageMental(),
                                                    ),
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                        Color(0xFFA8E6CF),
                                                      ),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                          horizontal: 30.w,
                                                        ),
                                                      ),
                                                ),
                                                child: Text('Mulai', style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h,),
                                Container(
                                  child: Card(
                                    child: Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/img/logoMental.png',
                                          ),
                                          SizedBox(width: 20.w),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Tes Guna AI dan Sensor',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF8A84FF),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 6.h),
                                              Container(
                                                width: 210.w,
                                                child: Text(
                                                  'Cek kondisi fisikmu dengan seberapa banyak gerakan pada tangan',
                                                  style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 10.sp)),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          const BiometricPage(),
                                                    ),
                                                  );
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                        Color(0xFFA8E6CF),
                                                      ),
                                                  padding:
                                                      MaterialStateProperty.all(
                                                        EdgeInsets.symmetric(
                                                          horizontal: 30.w,
                                                        ),
                                                      ),
                                                ),
                                                child: Text('Mulai', style: GoogleFonts.poppins(textStyle: TextStyle(color:Colors.white))),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.h,)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
    required String footer,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4FF),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            offset: const Offset(-6, -6),
            blurRadius: 12,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            offset: const Offset(6, 6),
            blurRadius: 12,
          ),
        ],
      ),
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F4FF),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.9),
                  offset: const Offset(-4, -4),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  offset: const Offset(4, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Icon(icon, size: 32, color: Colors.blue.shade700),
          ),

          const SizedBox(height: 20),

          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF4C5372)),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            onPressed: onPressed,
            child: Text(
              buttonText,
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(height: 10),

          Text(
            footer,
            style: const TextStyle(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Color(0xFF6A6F8C),
            ),
          ),
        ],
      ),
    );
  }
}
