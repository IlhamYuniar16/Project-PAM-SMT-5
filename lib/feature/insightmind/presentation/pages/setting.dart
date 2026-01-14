import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/dashboard_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool openGaris = true;

  @override
  void initState() {
    super.initState();
    _loadGarisTepi();
  }

  Future<void> _loadGarisTepi() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      openGaris = prefs.getBool('openGaris') ?? true;
    });
  }

  Future<void> _saveGarisTepi(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('openGaris', value);
    setState(() {
      openGaris = value;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF8A84FF),
        title: Row(
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
            Text(
              'Setting',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.sp,
                  color: Colors.white,
                ),
              ),
            ),
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
              color: Color(0xFF8A84FF),
              child: Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50.h),
                            Text(
                              'Personalisasi',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadiusDirectional.circular(
                                  10.r,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(FontAwesomeIcons.square),
                                              SizedBox(width: 10.w),
                                              Text('Garis Tepi'),
                                            ],
                                          ),
                                          Switch(
                                            value: openGaris,
                                            onChanged: (value) {
                                              _saveGarisTepi(value);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (openGaris) Divider(color: Colors.black),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
                                        });
                                      },
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                              Colors.transparent,
                                            ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  0,
                                                ),
                                          ),
                                        ),
                                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 5, vertical: 10))
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.dashboard, size: 25, color: Colors.black,),
                                          SizedBox(width: 10),
                                          Text(
                                            'Dashboard',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Tentang Aplikasi',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadiusDirectional.circular(
                                  10.r,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                        vertical: 10.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'assets/img/logonotext.png',
                                                width: 20.w,
                                              ),
                                              SizedBox(width: 7.w),
                                              Text(
                                                'SoulScan',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'v.0.0.1',
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (openGaris) Divider(color: Colors.black),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  5.r,
                                                ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.download,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                'Pembaharuan Aplikasi',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            FontAwesomeIcons.chevronRight,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (openGaris) Divider(color: Colors.black),
                                    ElevatedButton(
                                      onPressed: () {},
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                        ),
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadiusGeometry.circular(
                                                  5.r,
                                                ),
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.bug,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                'Laporkan Bug',
                                                style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            FontAwesomeIcons.chevronRight,
                                            color: Colors.black,
                                          ),
                                        ],
                                      ),
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
                  SizedBox(height: 50.h),
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
          ],
        ),
      ),
    );
  }
}
