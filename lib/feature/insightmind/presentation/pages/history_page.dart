// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:intl/intl.dart';
// import 'dart:io';

// import '../providers/history_providers.dart';
// import '../../data/local/screening_record.dart';
// import '../../data/local/history_repository.dart';

// class HistoryPage extends ConsumerWidget {
//   const HistoryPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final historyAsync = ref.watch(historyListProvider);
//     final exportStatus = ref.watch(exportStatusProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Image.asset('assets/img/logonotext.png', width: 40.w),
//                 SizedBox(width: 10.w),
//                 Text(
//                   'SoulScan',
//                   style: GoogleFonts.poppins(
//                     textStyle: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18.sp,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text('History'),
//                 SizedBox(width: 10.w),
//                 PopupMenuButton<String>(
//                   icon: exportStatus.entries.any((e) => e.value)
//                     ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
//                     : const Icon(Icons.more_vert, color: Colors.white),
//                   onSelected: (value) => _handleExportAction(value, ref),
//                   itemBuilder: (context) => [
//                     const PopupMenuItem(
//                       value: 'export_pdf_psikologi',
//                       child: Row(
//                         children: [
//                           Icon(Icons.picture_as_pdf, color: Colors.red),
//                           SizedBox(width: 8),
//                           Text('Export Psikologi PDF'),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuItem(
//                       value: 'export_pdf_mental',
//                       child: Row(
//                         children: [
//                           Icon(Icons.picture_as_pdf, color: Colors.blue),
//                           SizedBox(width: 8),
//                           Text('Export Mental PDF'),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuItem(
//                       value: 'export_all_pdf',
//                       child: Row(
//                         children: [
//                           Icon(Icons.picture_as_pdf, color: Colors.green),
//                           SizedBox(width: 8),
//                           Text('Export All PDF'),
//                         ],
//                       ),
//                     ),
//                     const PopupMenuDivider(),
//                     const PopupMenuItem(
//                       value: 'export_csv',
//                       child: Row(
//                         children: [
//                           Icon(Icons.table_chart, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text('Export as CSV'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//         automaticallyImplyLeading: false,
//         backgroundColor: const Color(0xFF8A84FF),
//       ),
//       body: historyAsync.when(
//         data: (items) {
//           if (items.isEmpty) {
//             return const Center(
//               child: Text(
//                 'Belum ada riwayat.',
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }
          
//           final psikologiItems = items.where((item) => item.testType == 'psikologi').toList();
//           final mentalItems = items.where((item) => item.testType == 'mental').toList();
          
//           return ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               if (psikologiItems.isNotEmpty) ...[
//                 _buildSectionHeader('Tes Psikologi', psikologiItems.length),
//                 ...psikologiItems.map((r) => _buildHistoryCard(r, ref)).toList(),
//                 const SizedBox(height: 20),
//               ],
              
//               if (mentalItems.isNotEmpty) ...[
//                 _buildSectionHeader('Tes Mental', mentalItems.length),
//                 ...mentalItems.map((r) => _buildHistoryCard(r, ref)).toList(),
//               ],
//             ],
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator(color: Colors.teal)),
//         error: (e, _) => Center(child: Text('Terjadi kesalahan: $e')),
//       ),
      
//       floatingActionButton: SafeArea(
//         minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//         child: FilledButton.icon(
//           icon: const Icon(Icons.delete_sweep),
//           label: const Text('Hapus Semua'),
//           style: FilledButton.styleFrom(
//             backgroundColor: Colors.redAccent,
//             padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
//           ),
//           onPressed: () async {
//             final ok = await showDialog<bool>(
//               context: context,
//               builder: (ctx) => AlertDialog(
//                 title: const Text('Konfirmasi'),
//                 content: const Text('Yakin ingin menghapus SEMUA riwayat?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(ctx, false),
//                     child: const Text('Batal'),
//                   ),
//                   FilledButton(
//                     onPressed: () => Navigator.pop(ctx, true),
//                     child: const Text('Hapus Semua'),
//                   ),
//                 ],
//               ),
//             );

//             if (ok == true) {
//               await ref.read(historyRepositoryProvider).clearAll();
//               ref.refresh(historyListProvider);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text('Semua riwayat telah dihapus'),
//                   backgroundColor: Colors.green,
//                 ),
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, int count) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF8A84FF),
//             ),
//           ),
//           Chip(
//             label: Text('$count records'),
//             backgroundColor: const Color(0xFF8A84FF).withOpacity(0.1),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistoryCard(ScreeningRecord r, WidgetRef ref) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       margin: const EdgeInsets.only(bottom: 10),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundColor: r.testType == 'psikologi' 
//             ? const Color(0xFFFFB7C5).withOpacity(0.3)
//             : const Color(0xFFA8E6CF).withOpacity(0.3),
//           child: Text(
//             r.score.toString(),
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: r.testType == 'psikologi' 
//                 ? const Color(0xFFFF6B8B)
//                 : const Color(0xFF4CAF50),
//             ),
//           ),
//         ),
//         title: Text(
//           'Risiko: ${r.riskLevel}',
//           style: const TextStyle(fontWeight: FontWeight.w600),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Waktu: ${DateFormat('dd/MM/yyyy HH:mm').format(r.timestamp)}'),
//             Text('Tipe: ${r.testType}'),
//             if (r.note != null && r.note!.isNotEmpty)
//               Text(
//                 'Catatan: ${r.note!.length > 50 ? '${r.note!.substring(0, 50)}...' : r.note!}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.delete, color: Colors.red),
//           onPressed: () async {
//             await ref.read(historyRepositoryProvider).deleteById(r.id);
//             ref.refresh(historyListProvider);

//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Riwayat dihapus'),
//                 backgroundColor: Colors.green,
//                 duration: Duration(seconds: 2),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Future<void> _handleExportAction(String action, WidgetRef ref) async {
//     try {
//       switch (action) {
//         case 'export_pdf_psikologi':
//           await _exportPDF(ref, 'psikologi');
//           break;
//         case 'export_pdf_mental':
//           await _exportPDF(ref, 'mental');
//           break;
//         case 'export_all_pdf':
//           await _exportAllPDF(ref);
//           break;
//         case 'export_csv':
//           await _exportCSV(ref);
//           break;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: ${e.toString()}'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _exportPDF(WidgetRef ref, String type) async {
//     final scaffold = ScaffoldMessenger.of(context);
//     final notifier = ref.read(
//       type == 'psikologi' 
//         ? psikologiHistoryProvider.notifier 
//         : mentalHistoryProvider.notifier,
//     );

//     scaffold.showSnackBar(
//       SnackBar(
//         content: Text('Generating ${type} PDF report...'),
//         duration: const Duration(seconds: 2),
//       ),
//     );

//     try {
//       final file = await notifier.exportToPDF();
//       scaffold.showSnackBar(
//         SnackBar(
//           content: Text('${type.toUpperCase()} PDF saved!'),
//           action: SnackBarAction(
//             label: 'Share',
//             onPressed: () => notifier.sharePDF(),
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     } catch (e) {
//       scaffold.showSnackBar(
//         SnackBar(
//           content: Text('Failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _exportAllPDF(WidgetRef ref) async {
//     final scaffold = ScaffoldMessenger.of(context);
//     scaffold.showSnackBar(
//       const SnackBar(
//         content: Text('Generating combined PDF report...'),
//         duration: Duration(seconds: 2),
//       ),
//     );

//     try {
//       final psikologi = ref.read(psikologiHistoryProvider);
//       final mental = ref.read(mentalHistoryProvider);
//       final allHistory = [...psikologi, ...mental]
//         ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

//       if (allHistory.isEmpty) {
//         scaffold.showSnackBar(
//           const SnackBar(
//             content: Text('No data to export'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }

//       final pdf = pw.Document();

//       pdf.addPage(
//         pw.Page(
//           pageFormat: PdfPageFormat.a4,
//           build: (pw.Context context) {
//             return pw.Column(
//               mainAxisAlignment: pw.MainAxisAlignment.center,
//               crossAxisAlignment: pw.CrossAxisAlignment.center,
//               children: [
//                 pw.Container(
//                   height: 80,
//                   width: 80,
//                   child: pw.ClipOval(
//                     child: pw.Container(
//                       color: PdfColor.fromHex("#8A84FF"),
//                       child: pw.Center(
//                         child: pw.Text(
//                           'SS',
//                           style: pw.TextStyle(
//                             fontSize: 36,
//                             color: PdfColors.white,
//                             fontWeight: pw.FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 pw.SizedBox(height: 20),
//                 pw.Text(
//                   'SoulScan Combined Report',
//                   style: pw.TextStyle(
//                     fontSize: 28,
//                     fontWeight: pw.FontWeight.bold,
//                     color: PdfColor.fromHex("#8A84FF"),
//                   ),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                   'Psikologi & Mental Health Screening',
//                   style: const pw.TextStyle(fontSize: 18),
//                 ),
//                 pw.SizedBox(height: 30),
//                 pw.Text(
//                   'Generated on: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now())}',
//                   style: const pw.TextStyle(fontSize: 12),
//                 ),
//                 pw.SizedBox(height: 10),
//                 pw.Text(
//                   'Total Records: ${allHistory.length} (Psikologi: ${psikologi.length}, Mental: ${mental.length})',
//                   style: const pw.TextStyle(fontSize: 12),
//                 ),
//               ],
//             );
//           },
//         ),
//       );

//       final bytes = await pdf.save();
//       final dir = await getApplicationDocumentsDirectory();
//       final fileName =
//           'soulscan_combined_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
//       final file = File('${dir.path}/$fileName');
//       await file.writeAsBytes(bytes);

//       scaffold.showSnackBar(
//         SnackBar(
//           content: const Text('Combined PDF saved successfully!'),
//           action: SnackBarAction(
//             label: 'Share',
//             onPressed: () async {
//               await Share.shareXFiles(
//                 [XFile(file.path)],
//                 text: 'SoulScan Combined Report',
//                 subject: 'Complete Screening History Report',
//               );
//             },
//           ),
//           duration: const Duration(seconds: 3),
//         ),
//       );
//     } catch (e) {
//       scaffold.showSnackBar(
//         SnackBar(
//           content: Text('Failed to generate combined PDF: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   Future<void> _exportCSV(WidgetRef ref) async {
//     final scaffold = ScaffoldMessenger.of(context);
//     scaffold.showSnackBar(
//       const SnackBar(
//         content: Text('Exporting to CSV...'),
//         duration: const Duration(seconds: 2),
//       ),
//     );

//     try {
//       final historyAsync = await ref.read(historyListProvider.future);
//       if (historyAsync.isEmpty) {
//         scaffold.showSnackBar(
//           const SnackBar(
//             content: Text('No data to export'),
//             backgroundColor: Colors.orange,
//           ),
//         );
//         return;
//       }

//       final csv = StringBuffer();
//       csv.writeln('ID,Date,Time,Score,Risk Level,Test Type,Note');
      
//       for (final record in historyAsync) {
//         csv.write('${record.id},');
//         csv.write('${DateFormat('yyyy-MM-dd').format(record.timestamp)},');
//         csv.write('${DateFormat('HH:mm:ss').format(record.timestamp)},');
//         csv.write('${record.score},');
//         csv.write('"${record.riskLevel}",');
//         csv.write('${record.testType},');
//         csv.writeln('"${record.note?.replaceAll('"', '""') ?? ""}"');
//       }

//       final String? path = await FilePicker.platform.saveFile(
//         dialogTitle: 'Save CSV File',
//         fileName: 'soulscan_history_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv',
//         allowedExtensions: ['csv'],
//       );

//       if (path != null) {
//         final file = File(path);
//         await file.writeAsString(csv.toString());
//         scaffold.showSnackBar(
//           SnackBar(
//             content: Text('CSV saved to: ${file.path}'),
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     } catch (e) {
//       scaffold.showSnackBar(
//         SnackBar(
//           content: Text('CSV export failed: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
// }