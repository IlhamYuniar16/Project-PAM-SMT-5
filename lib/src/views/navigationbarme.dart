import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/result_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/home_page.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/setting.dart';
import 'package:google_fonts/google_fonts.dart';


class Navigationbarme extends StatefulWidget {
  final int initialIndex;

  const Navigationbarme({super.key, this.initialIndex = 0});

  @override
  State<Navigationbarme> createState() => _NavigationbarmeState();
}

class _NavigationbarmeState extends State<Navigationbarme> {
  int selectedIndex = 0;

  final List<Widget> _listPage = [
    const HomePage(),
    const ResultPage(),
    const Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _listPage[selectedIndex],
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(top: 8.h, bottom: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE7E3FF), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, "Home", 0),
            _buildNavItem(Icons.history, "History", 1),
            _buildNavItem(Icons.settings_outlined, "Setting", 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? const Color(0xFF8A84FF)
                : const Color(0xFF7A76A8),
            size: 28.sp,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.poppins(textStyle: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF8A84FF)
                  : const Color(0xFF7A76A8),
            ),)
          ),
          SizedBox(height: 10.h,),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 4.h,
            width: isSelected ? 40.w : 0,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF8A84FF) : Colors.transparent,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4.r), topRight: Radius.circular(4.r)),
            ),
          ),
        ],
      ),
    );
  }
}


