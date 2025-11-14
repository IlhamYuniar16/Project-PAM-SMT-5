import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/screening_page_psikologi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MasalahPsikologi extends StatefulWidget {
  const MasalahPsikologi({super.key});

  @override
  State<MasalahPsikologi> createState() => _MasalahPsikologiState();
}

class _MasalahPsikologiState extends State<MasalahPsikologi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8A84FF),
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Masalah Psikologi',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
            Image.asset('assets/img/logonotext.png', width: 50.w),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(color: Color(0xFF8A84FF)),
              height: 1.sh,
              width: 1.sw,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 20.w,
                  vertical: 10.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kesehatan Psikologi Itu Penting',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Yuk Pelajari Lebih Dalam Masalah Dari Psikologi',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      'Supaya Tidak Mudah Terkena Gangguan Psikologi',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // width: 200.w,
                height: 630.h,
                decoration: BoxDecoration(
                  color: Color(0xFFC7C3FF),
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(32.r),
                    topEnd: Radius.circular(32.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          heightFactor: 2.h,
                          child: Card(
                            elevation: 1,
                            child: Container(width: 60.w, height: 7.h),
                          ),
                        ),
                        Text(
                          'Mengapa Penting Mempelajari Ini?',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Sesuai dengan tujuan utama kami ("Supaya Tidak Mudah Terkena Gangguan Psikologi"), mengenali "masalah psikologi" adalah langkah pertahanan pertama Anda.\n\nIni adalah berbagai tantangan umum yang memengaruhi cara kita berpikir, merasa, dan berperilaku. Mengalami ini BUKAN aib atau kelemahan; ini adalah respons wajar tubuh terhadap tekanan hidup.\n\nBanyak gangguan mental yang lebih serius seringkali berawal dari masalah-masalah ini yang menumpuk dan tidak dikelola dengan baik.\n\nDengan sadar (aware) terhadap tanda-tanda ini, Anda bisa mengambil tindakan lebih awal.',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 13.sp, height: 1.6),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Contoh Masalah Psikologi (Tantangan Sehari-hari):',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '• Stres Berat: Merasa tertekan atau kewalahan akibat tuntutan pekerjaan, sekolah, atau masalah keluarga.\n\n• Burnout (Kelelahan): Kelelahan fisik dan emosional yang ekstrem, seringkali terkait dengan pekerjaan atau rutinitas.\n\n• Masalah Hubungan: Mengalami konflik terus-menerus atau kesulitan berkomunikasi dengan orang terdekat.\n\n• Kepercayaan Diri Rendah: Perasaan negatif tentang diri sendiri yang menghambat Anda beraktivitas.\n\n• Kesulitan Mengelola Emosi: Mudah marah, cemas, atau sedih secara berlebihan dalam situasi sehari-hari.',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 13.sp, height: 1.6),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Color(0xFF8A84FF),
                                ),
                                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10.r)))
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ScreeningPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Tes Psikologi',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
