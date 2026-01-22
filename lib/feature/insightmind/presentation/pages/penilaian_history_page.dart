import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_project_pam/feature/insightmind/data/local/penilaian.dart';
import 'package:intl/intl.dart';

class PenilaianHistoryPage extends StatefulWidget {
  const PenilaianHistoryPage({super.key});

  @override
  State<PenilaianHistoryPage> createState() => _PenilaianHistoryPageState();
}

class _PenilaianHistoryPageState extends State<PenilaianHistoryPage> {
  late Box<Penilaian> penilaianBox;

  @override
  void initState() {
    super.initState();
    penilaianBox = Hive.box<Penilaian>('penilaian_history');
  }

  String _statusRating(int rating) {
    switch (rating) {
      case 1:
        return "Tidak Puas";
      case 2:
        return "Sedikit Puas";
      case 3:
        return "Lumayan Puas";
      case 4:
        return "Puas";
      case 5:
        return "Sangat Puas";
      default:
        return "";
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bug':
        return Colors.red.shade100;
      case 'Fitur':
        return Colors.blue.shade100;
      case 'Konten':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Bug':
        return Icons.bug_report;
      case 'Fitur':
        return Icons.lightbulb;
      case 'Konten':
        return Icons.article;
      default:
        return Icons.info;
    }
  }

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
              'Riwayat Penilaian',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
              ),
            ),
            Image.asset('assets/img/logonotext.png', width: 30.w),
          ],
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: penilaianBox.listenable(),
        builder: (context, Box<Penilaian> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Colors.grey.shade300),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat penilaian',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // Reverse to show newest first
          final penilaianList = box.values.toList().reversed.toList();

          return ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: penilaianList.length,
            itemBuilder: (context, index) {
              final penilaian = penilaianList[index];
              final formattedDate =
                  DateFormat('dd MMM yyyy, HH:mm').format(penilaian.timestamp);

              return Card(
                margin: EdgeInsets.only(bottom: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(penilaian.category),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(penilaian.category),
                                  size: 16,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 6.w),
                                Text(
                                  penilaian.category,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: List.generate(5, (starIndex) {
                              return Icon(
                                Icons.star,
                                size: 16,
                                color: starIndex < penilaian.rating
                                    ? Colors.amber
                                    : Colors.grey.shade300,
                              );
                            }),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                          ),
                          Text(_statusRating(penilaian.rating))
                        ],
                      ),
                      SizedBox(height: 8.h),
                      if (penilaian.feedback.isNotEmpty)
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            penilaian.feedback,
                            style: TextStyle(fontSize: 13.sp),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
