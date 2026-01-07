import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'dart:io';

import '../providers/history_providers.dart';
import '../../domain/entities/mental_result.dart';
import '../../domain/entities/ai_result.dart';
import 'history_detail_page.dart';
import 'ai_history_detail_page.dart';
import 'biometric_page.dart';

const Color kHistoryPageBackgroundColor = Color(0xFF8A84FF);
const Color kHistoryPageBodyColor = Color(0xFFC7C3FF);

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  bool _isExportingAll = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ==================== HELPER METHODS ====================
  
  // Helper untuk mengonversi AIResult ke MentalResult - GUNAKAN METHOD YANG SUDAH ADA
  MentalResult _convertAIResultToMentalResult(AIResult aiResult) {
    return aiResult.toMentalResult(); // GUNAKAN METHOD YANG SUDAH ADA DI AIResult
  }

  // ==================== EXPORT METHODS ====================

  Future<void> _handleExportAction(
    String action,
    WidgetRef ref,
    String currentTab,
  ) async {
    try {
      switch (action) {
        case 'export_pdf':
          if (currentTab == 'ai') {
            await _exportAIPDF(ref);
          } else {
            await _exportPDF(ref, currentTab);
          }
          break;
        case 'print':
          if (currentTab == 'ai') {
            await _printAIPDF(ref);
          } else {
            await _printPDF(ref, currentTab);
          }
          break;
        case 'share':
          if (currentTab == 'ai') {
            await _shareAIPDF(ref);
          } else {
            await _sharePDF(ref, currentTab);
          }
          break;
        case 'export_csv':
          if (currentTab == 'ai') {
            await _exportAICSV(ref);
          } else {
            await _exportCSV(ref, currentTab);
          }
          break;
        case 'export_all_pdf':
          await _exportAllPDF(ref);
          break;
        case 'print_all':
          await _printAllPDF(ref);
          break;
        case 'share_all':
          await _shareAllPDF(ref);
          break;
        case 'export_all_csv':
          await _exportAllCSV(ref);
          break;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportPDF(WidgetRef ref, String tabName) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(
      tabName == 'psikologi'
          ? psikologiHistoryProvider.notifier
          : mentalHistoryProvider.notifier,
    );

    scaffold.showSnackBar(
      SnackBar(
        content: Text('Generating ${tabName} PDF report...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final file = await notifier.exportToPDF();
      scaffold.showSnackBar(
        SnackBar(
          content: Text('${tabName.toUpperCase()} PDF saved successfully!'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () => notifier.sharePDF(),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportAIPDF(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(aiHistoryProvider.notifier);

    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Generating AI PDF report...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final file = await notifier.exportToPDF();
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('AI PDF saved successfully!'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () => notifier.sharePDF(),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Failed to generate AI PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _printPDF(WidgetRef ref, String tabName) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(
      tabName == 'psikologi'
          ? psikologiHistoryProvider.notifier
          : mentalHistoryProvider.notifier,
    );

    scaffold.showSnackBar(
      SnackBar(
        content: Text('Preparing ${tabName} report for printing...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await notifier.printPDF();
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Print job sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Print failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _printAIPDF(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(aiHistoryProvider.notifier);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Preparing AI report for printing...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      await notifier.printPDF();
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('AI print job sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('AI print failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _sharePDF(WidgetRef ref, String tabName) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(
      tabName == 'psikologi'
          ? psikologiHistoryProvider.notifier
          : mentalHistoryProvider.notifier,
    );

    scaffold.showSnackBar(
      SnackBar(
        content: Text('Preparing ${tabName} report for sharing...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      await notifier.sharePDF();
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Share failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareAIPDF(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(aiHistoryProvider.notifier);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Preparing AI report for sharing...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      await notifier.sharePDF();
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('AI share failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportCSV(WidgetRef ref, String tabName) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(
      tabName == 'psikologi'
          ? psikologiHistoryProvider.notifier
          : mentalHistoryProvider.notifier,
    );

    scaffold.showSnackBar(
      SnackBar(
        content: Text('Exporting ${tabName} data to CSV...'),
        duration: const Duration(seconds: 2),
      ),
    );

    try {
      final file = await notifier.saveCSVToFile();
      if (file != null) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text('CSV saved to: ${file.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('CSV export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportAICSV(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    final notifier = ref.read(aiHistoryProvider.notifier);

    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Exporting AI data to CSV...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final file = await notifier.saveCSVToFile();
      if (file != null) {
        scaffold.showSnackBar(
          SnackBar(
            content: Text('AI CSV saved to: ${file.path}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('AI CSV export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportAllPDF(WidgetRef ref) async {
    setState(() {
      _isExportingAll = true;
    });

    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Generating combined PDF report...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final psikologi = ref.read(psikologiHistoryProvider);
      final mental = ref.read(mentalHistoryProvider);
      final ai = ref.read(aiHistoryProvider);
      
      // PERBAIKAN: Gunakan method toMentalResult() yang sudah ada
      final List<MentalResult> allHistory = [
        ...psikologi,
        ...mental,
        ...ai.map((aiResult) => aiResult.toMentalResult()),
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (allHistory.isEmpty) {
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('No data to export'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  height: 80,
                  width: 80,
                  child: pw.ClipOval(
                    child: pw.Container(
                      color: PdfColor.fromHex("#8A84FF"),
                      child: pw.Center(
                        child: pw.Text(
                          'SS',
                          style: pw.TextStyle(
                            fontSize: 36,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'SoulScan Combined Report',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#8A84FF"),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Psikologi, Mental & AI Health Screening',
                  style: const pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Generated on: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total Records: ${allHistory.length} (Psikologi: ${psikologi.length}, Mental: ${mental.length}, AI: ${ai.length})',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      );

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  'Combined Screening History',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#8A84FF"),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  context: null,
                  border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#8A84FF")),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  headers: ['No', 'Type', 'Date', 'Score', 'Risk Level', 'Description'],
                  data: allHistory.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final result = entry.value;
                    return [
                      index.toString(),
                      result.testType,
                      DateFormat('dd/MM/yy').format(result.timestamp),
                      result.score.toString(),
                      result.riskLevel,
                      result.description.length > 40
                          ? '${result.description.substring(0, 40)}...'
                          : result.description,
                    ];
                  }).toList(),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'soulscan_combined_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Combined PDF saved successfully!'),
          action: SnackBarAction(
            label: 'Share',
            onPressed: () async {
              await Share.shareXFiles(
                [XFile(file.path)],
                text: 'SoulScan Combined Report',
                subject: 'Complete Screening History Report',
              );
            },
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Failed to generate combined PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isExportingAll = false;
      });
    }
  }

  Future<void> _printAllPDF(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Preparing combined report for printing...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final psikologi = ref.read(psikologiHistoryProvider);
      final mental = ref.read(mentalHistoryProvider);
      final ai = ref.read(aiHistoryProvider);
      
      // PERBAIKAN: Gunakan method toMentalResult() yang sudah ada
      final List<MentalResult> allHistory = [
        ...psikologi,
        ...mental,
        ...ai.map((aiResult) => aiResult.toMentalResult()),
      ];

      if (allHistory.isEmpty) {
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('No data to print'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  'SoulScan Combined History',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#8A84FF"),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  context: null,
                  border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    color: PdfColors.white,
                  ),
                  headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#8A84FF")),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  headers: ['No', 'Type', 'Date', 'Score', 'Risk Level'],
                  data: allHistory.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final result = entry.value;
                    return [
                      index.toString(),
                      result.testType,
                      DateFormat('dd/MM/yy').format(result.timestamp),
                      result.score.toString(),
                      result.riskLevel,
                    ];
                  }).toList(),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Printed: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 9),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      await Printing.layoutPdf(onLayout: (_) async => bytes);

      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Combined print job sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Print combined failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _shareAllPDF(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Preparing combined report for sharing...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final psikologi = ref.read(psikologiHistoryProvider);
      final mental = ref.read(mentalHistoryProvider);
      final ai = ref.read(aiHistoryProvider);
      
      // PERBAIKAN: Gunakan method toMentalResult() yang sudah ada
      final List<MentalResult> allHistory = [
        ...psikologi,
        ...mental,
        ...ai.map((aiResult) => aiResult.toMentalResult()),
      ];

      if (allHistory.isEmpty) {
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('No data to share'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(30),
          build: (pw.Context context) {
            return pw.Column(
              children: [
                pw.Text(
                  'SoulScan Combined Report',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#8A84FF"),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Total Records: ${allHistory.length}',
                  style: const pw.TextStyle(fontSize: 14),
                ),
                pw.Text(
                  'Psikologi: ${psikologi.length}, Mental: ${mental.length}, AI: ${ai.length}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Generated: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            );
          },
        ),
      );

      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'soulscan_summary_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'SoulScan Combined Report',
        subject: 'Complete Screening History Report',
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('Share combined failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _exportAllCSV(WidgetRef ref) async {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Exporting all data to CSV...'),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      final psikologi = ref.read(psikologiHistoryProvider);
      final mental = ref.read(mentalHistoryProvider);
      final ai = ref.read(aiHistoryProvider);
      
      // PERBAIKAN: Gunakan method toMentalResult() yang sudah ada
      final List<MentalResult> allHistory = [
        ...psikologi,
        ...mental,
        ...ai.map((aiResult) => aiResult.toMentalResult()),
      ]..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      if (allHistory.isEmpty) {
        scaffold.showSnackBar(
          const SnackBar(
            content: Text('No data to export'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final csv = StringBuffer();
      csv.writeln('No,Type,Date,Time,Score,Risk Level,Description');

      for (int i = 0; i < allHistory.length; i++) {
        final result = allHistory[i];
        csv.write('${i + 1},');
        csv.write('${result.testType},');
        csv.write('${DateFormat('yyyy-MM-dd').format(result.timestamp)},');
        csv.write('${DateFormat('HH:mm:ss').format(result.timestamp)},');
        csv.write('${result.score},');
        csv.write('"${result.riskLevel}",');
        csv.writeln('"${result.description.replaceAll('"', '""')}"');
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/soulscan_combined_history.csv');
      await file.writeAsString(csv.toString());

      scaffold.showSnackBar(
        SnackBar(
          content: Text('Combined CSV saved to: ${file.path}'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      scaffold.showSnackBar(
        SnackBar(
          content: Text('CSV export failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildAIHistoryList(List<AIResult> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy,
              size: 60.w,
              color: kHistoryPageBackgroundColor.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No AI assessments yet',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Complete an AI assessment to see results here',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
              ),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BiometricPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kHistoryPageBackgroundColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                child: Text(
                  'Start AI Assessment',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AIHistoryDetailPage(result: result),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: Colors.purple.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.smart_toy,
                        color: Colors.purple,
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd MMM yyyy, HH:mm').format(result.timestamp),
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'AI Powered',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'AI Health Assessment',
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getRiskLevelColor(result.riskLevel).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                result.riskLevel,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: _getRiskLevelColor(result.riskLevel),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Score: ${result.score}',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 1.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                '${(result.aiConfidence * 100).toStringAsFixed(0)}%',
                                style: GoogleFonts.poppins(
                                  fontSize: 10.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          result.description.length > 80
                              ? '${result.description.substring(0, 80)}...'
                              : result.description,
                          style: GoogleFonts.poppins(
                            fontSize: 11.sp,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'PPG: ${result.ppgMean.toStringAsFixed(2)} | '
                          'Activity: ${result.activityMean.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (result.recommendations.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              result.recommendations[0],
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.green.shade700,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 24.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistoryList(List<MentalResult> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 60.w,
              color: kHistoryPageBackgroundColor.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              'No results yet',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Complete a screening to see results here',
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final result = results[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryDetailPage(
                    title: result.testType == 'psikologi' 
                      ? 'History Psikologi' 
                      : 'History Mental', 
                    result: result,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16.r),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: _getRiskLevelColor(result.riskLevel).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        _getRiskLevelIcon(result.riskLevel),
                        color: _getRiskLevelColor(result.riskLevel),
                        size: 24.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(result.timestamp),
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          result.testType,
                          style: GoogleFonts.poppins(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: _getRiskLevelColor(result.riskLevel)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                result.riskLevel,
                                style: GoogleFonts.poppins(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: _getRiskLevelColor(result.riskLevel),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Score: ${result.score}',
                              style: GoogleFonts.poppins(
                                fontSize: 12.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          result.description.length > 80
                              ? '${result.description.substring(0, 80)}...'
                              : result.description,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey.shade400,
                    size: 24.w,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getRiskLevelColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      default:
        return kHistoryPageBackgroundColor;
    }
  }

  IconData _getRiskLevelIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Icons.sentiment_satisfied;
      case 'medium':
        return Icons.sentiment_neutral;
      case 'high':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.psychology;
    }
  }

  void _showDeleteAllDialog(
    BuildContext context,
    WidgetRef ref,
    String tabType,
  ) {
    final tabName = tabType == 'psikologi' ? 'Psikologi' : 
                    tabType == 'mental' ? 'Mental' : 'AI';
    
    StateNotifierProvider? provider;
    if (tabType == 'psikologi') {
      provider = psikologiHistoryProvider;
    } else if (tabType == 'mental') {
      provider = mentalHistoryProvider;
    } else if (tabType == 'ai') {
      provider = aiHistoryProvider;
    }

    if (provider == null) return;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Hapus Semua Riwayat $tabName'),
        content: Text(
          'Apakah Anda yakin ingin menghapus SEMUA riwayat tes $tabName? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              // PERBAIKAN: Panggil clearHistory dengan benar
              final notifier = ref.read(provider!.notifier);
              if (tabType == 'psikologi') {
                (notifier as HistoryNotifier).clearHistory();
              } else if (tabType == 'mental') {
                (notifier as HistoryNotifier).clearHistory();
              } else if (tabType == 'ai') {
                (notifier as AIHistoryNotifier).clearHistory();
              }
              
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Semua riwayat tes $tabName berhasil dihapus'),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Hapus Semua',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kHistoryPageBackgroundColor,
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
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'History',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Consumer(
                  builder: (context, ref, child) {
                    final exportStatus = ref.watch(exportStatusProvider);
                    final currentTab = _currentTabIndex == 0
                        ? 'psikologi'
                        : _currentTabIndex == 1
                            ? 'mental'
                            : 'ai';
                    final isExporting = exportStatus[currentTab] ?? false;

                    return PopupMenuButton<String>(
                      icon: isExporting
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) =>
                          _handleExportAction(value, ref, currentTab),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'export_pdf',
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf, size: 20.w, color: Colors.red),
                                SizedBox(width: 8.w),
                                Text('Export ${currentTab} PDF'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'print',
                            child: Row(
                              children: [
                                Icon(Icons.print, size: 20.w, color: Colors.blue),
                                SizedBox(width: 8.w),
                                Text('Print ${currentTab} Report'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'share',
                            child: Row(
                              children: [
                                Icon(Icons.share, size: 20.w, color: Colors.green),
                                SizedBox(width: 8.w),
                                Text('Share ${currentTab} Report'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'export_csv',
                            child: Row(
                              children: [
                                Icon(Icons.table_chart, size: 20.w, color: Colors.orange),
                                SizedBox(width: 8.w),
                                Text('Export ${currentTab} CSV'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'export_all_pdf',
                            child: Row(
                              children: [
                                Icon(Icons.picture_as_pdf_outlined, size: 20.w, color: Colors.orange),
                                SizedBox(width: 8.w),
                                Text('Export All PDF', style: TextStyle(color: Colors.orange)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'export_all_csv',
                            child: Row(
                              children: [
                                Icon(Icons.table_chart_outlined, size: 20.w, color: Colors.orange),
                                SizedBox(width: 8.w),
                                Text('Export All CSV', style: TextStyle(color: Colors.orange)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'print_all',
                            child: Row(
                              children: [
                                Icon(Icons.print_outlined, size: 20.w, color: Colors.orange),
                                SizedBox(width: 8.w),
                                Text('Print All', style: TextStyle(color: Colors.orange)),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'share_all',
                            child: Row(
                              children: [
                                Icon(Icons.share_outlined, size: 20.w, color: Colors.orange),
                                SizedBox(width: 8.w),
                                Text('Share All', style: TextStyle(color: Colors.orange)),
                              ],
                            ),
                          ),
                        ];
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: kHistoryPageBackgroundColor,
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          StateNotifierProvider? provider;
          if (_currentTabIndex == 0) {
            provider = psikologiHistoryProvider;
          } else if (_currentTabIndex == 1) {
            provider = mentalHistoryProvider;
          } else {
            provider = aiHistoryProvider;
          }

          List historyList;
          if (provider == psikologiHistoryProvider) {
            historyList = ref.watch(psikologiHistoryProvider);
          } else if (provider == mentalHistoryProvider) {
            historyList = ref.watch(mentalHistoryProvider);
          } else {
            historyList = ref.watch(aiHistoryProvider);
          }

          if (historyList.isEmpty) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton(
            onPressed: () {
              final currentTab = _currentTabIndex == 0 
                ? 'psikologi' 
                : _currentTabIndex == 1 
                  ? 'mental' 
                  : 'ai';
              _showDeleteAllDialog(context, ref, currentTab);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            elevation: 4.0,
            child: const Icon(Icons.delete_sweep),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Container(
                    child: Text(
                      'Yukk Jaga Kesehatan Mental dan Psikologi kalian',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kHistoryPageBodyColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.r),
                        topRight: Radius.circular(30.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.w),
                          height: 40.h,
                          child: TabBar(
                            controller: _tabController,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 3.0.w,
                              ),
                            ),
                            labelColor: kHistoryPageBackgroundColor,
                            unselectedLabelColor: Colors.white,
                            labelStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp,
                              ),
                            ),
                            unselectedLabelStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.sp,
                              ),
                            ),
                            tabs: const [
                              Tab(text: 'Psikologi'),
                              Tab(text: 'Mental'),
                              Tab(text: 'AI Tes'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              Consumer(
                                builder: (context, ref, child) {
                                  final psikologiResults = ref.watch(psikologiHistoryProvider);
                                  return _buildHistoryList(psikologiResults);
                                },
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  final mentalResults = ref.watch(mentalHistoryProvider);
                                  return _buildHistoryList(mentalResults);
                                },
                              ),
                              Consumer(
                                builder: (context, ref, child) {
                                  final aiResults = ref.watch(aiHistoryProvider);
                                  return _buildAIHistoryList(aiResults);
                                },
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
            if (_isExportingAll)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: kHistoryPageBackgroundColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}