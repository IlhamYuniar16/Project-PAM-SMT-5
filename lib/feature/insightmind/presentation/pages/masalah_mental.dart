import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/screening_page_mental.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MasalahMental extends StatefulWidget {
  const MasalahMental({super.key});

  @override
  State<MasalahMental> createState() => _MasalahMentalState();
}

class _MasalahMentalState extends State<MasalahMental> {
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
              'Masalah Mental',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
            Image.asset('assets/img/logonotext.png', width: 30.w),
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
                      'Kesehatan Mental Itu Penting',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Cek kondisi diri seperti detok, jantung, gula, dan tingkat energi',
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
                        SizedBox(height: 20.h,),
                        Text(
                          'Kesehatan Mental Itu Penting',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Kesehatan mental sama pentingnya dengan kesehatan fisik. Tidak ada kata "sehat" yang utuh tanpa kesehatan mental yang baik.\n\nMasalah mental, atau sering disebut Gangguan Psikologi, adalah kondisi kesehatan yang didiagnosis secara klinis. Ini lebih dari sekadar stres biasa dan dapat memengaruhi kemampuan seseorang untuk beraktivitas sehari-hari.',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 13.sp, height: 1.6),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Pesan Kesadaran (Awareness) Kami:',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '• Ini Nyata: Gangguan mental adalah kondisi medis yang nyata, sama seperti diabetes atau asma. Ini bukan kegagalan karakter atau "kurang iman".\n\n• Anda Tidak Sendiri: Jutaan orang di dunia mengalaminya. Stigma dan rasa malu adalah penghalang terbesar untuk sembuh.\n\n• Bisa Ditangani: Dengan penanganan yang tepat (baik terapi, konseling, atau obat), pemulihan sangat mungkin terjadi.\n\nMempelajari tentang ini membantu kita menghancurkan stigma dan lebih berani mencari atau menawarkan bantuan.',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(fontSize: 13.sp, height: 1.6),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Contoh Umum Masalah Mental (Gangguan Klinis):',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          '• Depresi: Perasaan sedih yang mendalam dan kehilangan minat terhadap banyak hal secara terus-menerus.\n\n• Gangguan Kecemasan (Anxiety Disorder): Rasa cemas, takut, atau panik yang intens, berlebihan, dan seringkali tidak terkendali.\n\n• Gangguan Bipolar: Perubahan suasana hati yang ekstrem, dari sangat bersemangat (mania) ke sangat sedih (depresi).',
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
                                    builder: (_) => const ScreeningPageMental(),
                                  ),
                                );
                              },
                              child: Text(
                                'Tes Mental',
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
