import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:flutter_project_pam/feature/insightmind/presentation/pages/home_page.dart';
import 'package:flutter_project_pam/src/views/page_utama.dart';
// import 'package:flutter_app_new/src/components/navigation.dart';
// import 'package:flutter_app_new/src/views/pagehomelain.dart';
// import 'package:flutter_app_new/src/views/pagehomelain.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HompSplashMe extends StatelessWidget {
  const HompSplashMe({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(399, 845),
      splitScreenMode: true,
      minTextAdapt: true,
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Lynxx',
          home: HomeSplash(),
        );
      },
    );
  }
}

class HomeSplash extends StatefulWidget {
  const HomeSplash({super.key});

  @override
  State<HomeSplash> createState() => _HomeSplashState();
}

class _HomeSplashState extends State<HomeSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xFFC7C3FF),
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          color:  Color(0xFFC7C3FF),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              FadeTransition(
                opacity: _fadeAnim,
                child: ScaleTransition(
                  scale: _scaleAnim,
                  child: Column(
                    children: [
                      Image.asset('assets/img/logonotext.png', width: 100.w,),
                      Text('SoulScan', style: GoogleFonts.poppins(textStyle: TextStyle(color: Colors.black, fontSize: 30.sp, fontWeight: FontWeight.bold)),)
                    ],
                  ) 
                ),
              ),
            ] 
          ),
        ),
      ),
    );
  }
}
