// lib/features/insightmind/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
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
        backgroundColor: Color(0xFF8A84FF),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Stack(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Color(0xFF8A84FF),
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
                  color: Color(0xFFC7C3FF),
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
                                            // width: 50.w,
                                            // color: Color(0xFFFFB7C5),
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
                                            // color: Color(0xFFA8E6CF),
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
                                                          // vertical: 2.h,
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(height: 100.h),
                    //     Text('Content'),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            //   child: FilledButton.icon(
            //     icon: const Icon(Icons.psychology_alt),
            //     label: const Text('Mulai Screening'),
            //     style: FilledButton.styleFrom(
            //       backgroundColor: Colors.indigo,
            //       padding: const EdgeInsets.symmetric(vertical: 16),
            //     ),
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (_) => const ScreeningPage()),
            //       );
            //     },
            //   ),
            // ),

            // const SizedBox(height: 32),
            // const Divider(thickness: 1),

            // const Text(
            //   'Latihan Minggu 2 - Simulasi Jawaban',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // Wrap(
            //   spacing: 8,
            //   children: [
            //     for (int i = 0; i < answers.length; i++)
            //       Chip(label: Text('${answers[i]}')),
            //   ],
            // ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.indigo,
      //   foregroundColor: Colors.white,
      //   onPressed: () {
      //     // Tambah data dummy (latihan minggu 2)
      //     final newValue = (DateTime.now().millisecondsSinceEpoch % 4).toInt();
      //     final current = [...ref.read(answersProvider)];
      //     current.add(newValue);
      //     ref.read(answersProvider.notifier).state = current;
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
