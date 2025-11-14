import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/home_page.dart';
import 'package:flutter_project_pam/src/views/navigationbarme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFC7C3FF),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFC7C3FF),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset('assets/img/gambar2.png'),
                Column(
                  children: [
                    Text('Kenali Dirimu Lebih Dalam', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.w900, color: Color(0xFF3B3A4E))),),
                    SizedBox(height: 10.h,),
                    Text(style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 15.sp, color: Color(0xFF8F8CAB))), textAlign: TextAlign.center,'Setiap orang punya sisi diri yang mungkin belum sepenuhnya mereka pahami. Lewat perjalanan kecil ini, kamu akan diajak merenung dan menemukan gambaran yang lebih jujur tentang siapa dirimu sebenarnya.')
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const Navigationbarme()));
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:  MaterialStateProperty.all(Color(0xFF8A84FF)),
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h)),

                    // shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(10.r)))
                  ),
                  child: Text('Mulai', style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 18.sp, color: Colors.white)),),
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}