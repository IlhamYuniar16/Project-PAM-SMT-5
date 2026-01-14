import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/screening_page_psikologi.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class penilaian extends StatefulWidget {
  const penilaian({super.key});

  @override
  State<penilaian> createState() => _penilaianState();
}

class _penilaianState extends State<penilaian> {
  String? selectedCategory;
TextEditingController feedbackController = TextEditingController();

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
              'Berikan Penilaian',
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
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                // width: 200.w,
                height: 720.h,
                decoration: BoxDecoration(
                  color: Color(0xFFC7C3FF),
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: Radius.circular(32.r),
                    topEnd: Radius.circular(32.r),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 25.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                  'assets/img/heart.png',
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Suara anda sangat berarti',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold
                                ), 
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Bantu kami menciptakan pengalaman aplikasi yang lebih baik dan nyaman untukmu.',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 26,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 26,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 26,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 26,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.star,
                                    size: 26,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Sangat Puas!'
                              )
                            ],
                          ),
                        ),
                        Divider(
                          height: 50,
                          color: Color(0xFFE0E0E0),
                        ),
                        Text(
                          'Apa yang bisa kami perbaiki?',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            ChoiceChip(
                              label: const Text('Bug'),
                              selected: selectedCategory == 'Bug',
                              onSelected: (value) {
                                setState(() {
                                  selectedCategory = 'Bug';
                                });
                              },
                              selectedColor: Color(0xFF8A84FF),
                              labelStyle: TextStyle(
                                color: selectedCategory == 'Bug'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            ChoiceChip(
                              label: const Text('Fitur'),
                              selected: selectedCategory == 'Fitur',
                              onSelected: (value) {
                                setState(() {
                                  selectedCategory = 'Fitur';
                                });
                              },
                              selectedColor: Color(0xFF8A84FF),
                              labelStyle: TextStyle(
                                color: selectedCategory == 'Fitur'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            ChoiceChip(
                              label: const Text('Konten'),
                              selected: selectedCategory == 'Konten',
                              onSelected: (value) {
                                setState(() {
                                  selectedCategory = 'Konten';
                                });
                              },
                              selectedColor: Color(0xFF8A84FF),
                              labelStyle: TextStyle(
                                color: selectedCategory == 'Konten'
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Ceritakan masukanmu (opsional)',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: feedbackController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Tulis masukan anda di sini...',
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.all(12.w),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48.h,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF8A84FF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.r),
                              ),
                            ),
                            onPressed: (){},
                            child: Text(
                              'Kirim Penilaian',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Colors.grey.shade700,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Ulasan kamu bersifat anonim',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'SoulScan - VERSI 0.0.1',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Text(
                                '2025 @SoulScan',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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