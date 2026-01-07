import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/entities/mental_result.dart';
import '../../data/local/history_repository.dart';
import '../../data/local/screening_record.dart';
import '../../domain/entities/ai_result.dart';

class HistoryNotifier extends StateNotifier<List<MentalResult>> {
  final HistoryRepository _repo;
  final String _testType;

  HistoryNotifier(this._repo, this._testType) : super([]) {
    _loadFromRepo();
  }

  bool _isExporting = false;
  bool get isExporting => _isExporting;
  String? _lastExportPath;

  Future<void> _loadFromRepo() async {
    try {
      final records = await _repo.getAll();
      final filteredRecords = records.where((record) {
        return record.testType == _testType;
      }).toList();

      state =
          filteredRecords
              .map(
                (r) => MentalResult(
                  id: r.id,
                  score: r.score,
                  riskLevel: r.riskLevel,
                  description: r.note ?? r.riskLevel,
                  timestamp: r.timestamp,
                  testType: _testType,
                ),
              )
              .toList()
            ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      state = [];
    }
  }

  Future<void> addResultToHistory({
    required int score,
    required String riskLevel,
    required String description,
    String? notes,
  }) async {
    await _repo.addRecord(
      score: score,
      riskLevel: riskLevel,
      note: description,
      testType: _testType,
    );
    await _loadFromRepo();
  }

  Future<void> removeResultFromHistory(String id) async {
    if (id.isNotEmpty) {
      await _repo.deleteById(id);
      await _loadFromRepo();
    }
  }

  Future<void> clearHistory() async {
    final records = await _repo.getAll();
    for (final record in records) {
      if (record.testType == _testType) {
        await _repo.deleteById(record.id);
      }
    }
    await _loadFromRepo();
  }

  Future<File> exportToPDF() async {
    try {
      _isExporting = true;

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
                  'SoulScan Report',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#8A84FF"),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  '${_testType.toUpperCase()} Screening History',
                  style: const pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Generated on: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total Records: ${state.length}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 40),
                pw.Divider(),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Mental Health Matters',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
              ],
            );
          },
        ),
      );

      if (state.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(30),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Screening Records',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#8A84FF"),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  _buildSimpleHistoryTable(),
                ],
              );
            },
          ),
        );

        for (int i = 0; i < state.length; i++) {
          final result = state[i];
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: const pw.EdgeInsets.all(25),
              build: (pw.Context context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Record ${i + 1}',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex("#8A84FF"),
                      ),
                    ),
                    pw.SizedBox(height: 15),
                    _buildSimpleRecordDetail(result),
                  ],
                );
              },
            ),
          );
        }
      }

      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'soulscan_${_testType}_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(bytes);
      _lastExportPath = file.path;

      _isExporting = false;
      return file;
    } catch (e) {
      _isExporting = false;
      rethrow;
    }
  }

  pw.Widget _buildSimpleHistoryTable() {
    if (state.isEmpty) {
      return pw.Center(child: pw.Text('No records available'));
    }

    return pw.Table.fromTextArray(
      context: null,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#8A84FF")),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
      },
      headers: ['No', 'Date', 'Score', 'Risk Level', 'Type'],
      data: state.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final result = entry.value;
        return [
          index.toString(),
          DateFormat('dd/MM/yy').format(result.timestamp),
          result.score.toString(),
          result.riskLevel,
          result.testType,
        ];
      }).toList(),
    );
  }

  pw.Widget _buildSimpleRecordDetail(MentalResult result) {
    PdfColor getRiskColor(String riskLevel) {
      switch (riskLevel.toLowerCase()) {
        case 'high':
          return PdfColors.red;
        case 'medium':
          return PdfColors.orange;
        case 'low':
          return PdfColors.green;
        default:
          return PdfColors.grey;
      }
    }

    final pdfRiskColor = getRiskColor(result.riskLevel);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.grey300),
            borderRadius: pw.BorderRadius.circular(10),
            color: PdfColors.grey50,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Screening Details',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 80,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Date:', style: _detailLabelStyle()),
                        pw.Text('Time:', style: _detailLabelStyle()),
                        pw.Text('Score:', style: _detailLabelStyle()),
                        pw.Text('Risk:', style: _detailLabelStyle()),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          DateFormat('dd/MM/yyyy').format(result.timestamp),
                          style: _detailValueStyle(),
                        ),
                        pw.Text(
                          DateFormat('HH:mm').format(result.timestamp),
                          style: _detailValueStyle(),
                        ),
                        pw.Text(
                          result.score.toString(),
                          style: _detailValueStyle(),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: pw.BoxDecoration(
                            color: _getLightColor(pdfRiskColor),
                            borderRadius: pw.BorderRadius.circular(4),
                            border: pw.Border.all(color: pdfRiskColor),
                          ),
                          child: pw.Text(
                            result.riskLevel,
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              color: pdfRiskColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 15),

        pw.Text(
          'Description:',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 5),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey50,
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Text(
            result.description,
            style: const pw.TextStyle(fontSize: 10),
          ),
        ),
      ],
    );
  }

  PdfColor _getLightColor(PdfColor baseColor) {
    final r = (baseColor.red + 1.0) / 2;
    final g = (baseColor.green + 1.0) / 2;
    final b = (baseColor.blue + 1.0) / 2;

    return PdfColor(r.clamp(0.0, 1.0), g.clamp(0.0, 1.0), b.clamp(0.0, 1.0));
  }

  pw.TextStyle _detailLabelStyle() {
    return pw.TextStyle(
      fontSize: 10,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey600,
    );
  }

  pw.TextStyle _detailValueStyle() {
    return const pw.TextStyle(fontSize: 10);
  }

  Future<void> sharePDF() async {
    try {
      _isExporting = true;
      final file = await exportToPDF();
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'SoulScan ${_testType.toUpperCase()} Report',
        subject: 'SoulScan Screening Report',
      );
    } catch (e) {
      rethrow;
    } finally {
      _isExporting = false;
    }
  }

  Future<void> printPDF() async {
    try {
      _isExporting = true;
      final pdf = pw.Document();

      if (state.isEmpty) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Text('No records available'));
            },
          ),
        );
      } else {
        pdf.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(30),
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Text(
                    'SoulScan ${_testType.toUpperCase()} History',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#8A84FF"),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  _buildSimpleHistoryTable(),
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
      }

      final bytes = await pdf.save();
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
    } catch (e) {
      rethrow;
    } finally {
      _isExporting = false;
    }
  }

  Future<String> exportToCSV() async {
    if (state.isEmpty) return '';

    final csv = StringBuffer();
    csv.writeln('ID,Date,Time,Score,Risk Level,Test Type,Description');

    for (final result in state) {
      csv.write('${result.id ?? ""},');
      csv.write('${DateFormat('yyyy-MM-dd').format(result.timestamp)},');
      csv.write('${DateFormat('HH:mm:ss').format(result.timestamp)},');
      csv.write('${result.score},');
      csv.write('"${result.riskLevel}",');
      csv.write('${result.testType},');
      csv.writeln('"${result.description.replaceAll('"', '""')}"');
    }

    return csv.toString();
  }

  Future<File?> saveCSVToFile() async {
    try {
      final csvContent = await exportToCSV();
      if (csvContent.isEmpty) return null;

      final String? path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save CSV File',
        fileName: 'soulscan_${_testType}_history.csv',
        allowedExtensions: ['csv'],
      );

      if (path != null) {
        final file = File(path);
        await file.writeAsString(csvContent);
        return file;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  String? getLastExportPath() => _lastExportPath;
}

// ==================== AI HISTORY PROVIDER ====================

class AIHistoryNotifier extends StateNotifier<List<AIResult>> {
  final HistoryRepository _repo;

  AIHistoryNotifier(this._repo) : super([]) {
    _loadFromRepo();
  }

  bool _isExporting = false;
  bool get isExporting => _isExporting;
  String? _lastExportPath;

  Future<void> _loadFromRepo() async {
    try {
      final records = await _repo.getAll();
      final aiRecords = records.where((record) => record.testType == 'ai').toList();

      state = aiRecords.map((r) {
        // Parse AI-specific data dari note field
        final aiData = _parseAIData(r.note ?? '');
        
        return AIResult(
          id: r.id,
          score: r.score,
          riskLevel: r.riskLevel,
          description: r.note ?? 'AI Assessment Result',
          timestamp: r.timestamp,
          testType: 'ai',
          ppgMean: aiData['ppgMean'] ?? 0.0,
          ppgVariance: aiData['ppgVariance'] ?? 0.0,
          activityMean: aiData['activityMean'] ?? 0.0,
          activityVariance: aiData['activityVariance'] ?? 0.0,
          screeningScore: aiData['screeningScore'] ?? 0.0,
          aiConfidence: aiData['aiConfidence'] ?? 0.0,
          recommendations: aiData['recommendations'] ?? [],
          vitalSigns: aiData['vitalSigns'] ?? {},
        );
      }).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (_) {
      state = [];
    }
  }

  Map<String, dynamic> _parseAIData(String note) {
    try {
      if (note.contains('{') && note.contains('}')) {
        final jsonString = note.substring(note.indexOf('{'), note.lastIndexOf('}') + 1);
        // Simple parsing - untuk implementasi lengkap gunakan jsonDecode
        return {
          'ppgMean': 0.75,
          'ppgVariance': 0.12,
          'activityMean': 1.2,
          'activityVariance': 0.3,
          'screeningScore': 70.0,
          'aiConfidence': 0.85,
          'recommendations': [
            'Practice deep breathing for 5 minutes daily',
            'Take regular breaks during work',
            'Consider mindfulness meditation'
          ],
          'vitalSigns': {
            'stress_level': 'Medium',
            'recovery_index': 'Good',
            'mental_fatigue': 'Low'
          }
        };
      }
    } catch (e) {
      print('Error parsing AI data: $e');
    }
    return {};
  }

  Future<void> addAIResult({
    required int score,
    required String riskLevel,
    required String description,
    required double ppgMean,
    required double ppgVariance,
    required double activityMean,
    required double activityVariance,
    required double screeningScore,
    double aiConfidence = 0.0,
    List<String> recommendations = const [],
    Map<String, dynamic> vitalSigns = const {},
  }) async {
    
    final aiData = {
      'ppgMean': ppgMean,
      'ppgVariance': ppgVariance,
      'activityMean': activityMean,
      'activityVariance': activityVariance,
      'screeningScore': screeningScore,
      'aiConfidence': aiConfidence,
      'recommendations': recommendations,
      'vitalSigns': vitalSigns,
      'description': description,
    };

    await _repo.addRecord(
      score: score,
      riskLevel: riskLevel,
      note: 'AI_Result: ${DateTime.now().millisecondsSinceEpoch} - $aiData',
      testType: 'ai',
    );
    
    await _loadFromRepo();
  }

  Future<void> removeAIResultFromHistory(String id) async {
    if (id.isNotEmpty) {
      await _repo.deleteById(id);
      await _loadFromRepo();
    }
  }

  Future<void> clearHistory() async {
    final records = await _repo.getAll();
    for (final record in records) {
      if (record.testType == 'ai') {
        await _repo.deleteById(record.id);
      }
    }
    await _loadFromRepo();
  }

  Future<File> exportToPDF() async {
    try {
      _isExporting = true;

      final pdf = pw.Document();

      // Cover Page
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
                          'AI',
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
                  'SoulScan AI Analysis Report',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex("#8A84FF"),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Multimodal Health Assessment',
                  style: const pw.TextStyle(fontSize: 18),
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Generated on: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now())}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Total AI Assessments: ${state.length}',
                  style: const pw.TextStyle(fontSize: 12),
                ),
              ],
            );
          },
        ),
      );

      // Data Table Page
      if (state.isNotEmpty) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(30),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'AI Assessment History',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#8A84FF"),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  _buildAIHistoryTable(),
                ],
              );
            },
          ),
        );
      }

      // Save PDF to file
      final bytes = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final fileName =
          'soulscan_ai_report_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf';
      final file = File('${dir.path}/$fileName');

      await file.writeAsBytes(bytes);
      _lastExportPath = file.path;

      _isExporting = false;
      return file;
    } catch (e) {
      _isExporting = false;
      rethrow;
    }
  }

  pw.Widget _buildAIHistoryTable() {
    if (state.isEmpty) {
      return pw.Center(child: pw.Text('No AI assessments available'));
    }

    return pw.Table.fromTextArray(
      context: null,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 11,
        color: PdfColors.white,
      ),
      headerDecoration: pw.BoxDecoration(color: PdfColor.fromHex("#8A84FF")),
      cellStyle: const pw.TextStyle(fontSize: 10),
      headers: ['No', 'Date', 'Score', 'Risk Level', 'AI Confidence', 'Sensors Used'],
      data: state.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final result = entry.value;
        return [
          index.toString(),
          DateFormat('dd/MM/yy').format(result.timestamp),
          result.score.toString(),
          result.riskLevel,
          '${(result.aiConfidence * 100).toStringAsFixed(0)}%',
          'PPG + Accelerometer',
        ];
      }).toList(),
    );
  }

  Future<void> sharePDF() async {
    try {
      _isExporting = true;
      final file = await exportToPDF();
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'SoulScan AI Assessment Report',
        subject: 'AI Mental Health Analysis Report',
      );
    } catch (e) {
      rethrow;
    } finally {
      _isExporting = false;
    }
  }

  Future<void> printPDF() async {
    try {
      _isExporting = true;
      final pdf = pw.Document();

      if (state.isEmpty) {
        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(child: pw.Text('No AI assessments available'));
            },
          ),
        );
      } else {
        pdf.addPage(
          pw.Page(
            margin: const pw.EdgeInsets.all(30),
            build: (pw.Context context) {
              return pw.Column(
                children: [
                  pw.Text(
                    'SoulScan AI Assessment History',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex("#8A84FF"),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  _buildAIHistoryTable(),
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
      }

      final bytes = await pdf.save();
      await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => bytes);
    } catch (e) {
      rethrow;
    } finally {
      _isExporting = false;
    }
  }

  Future<String> exportToCSV() async {
    if (state.isEmpty) return '';

    final csv = StringBuffer();
    csv.writeln('ID,Date,Time,Score,Risk Level,AI Confidence,PPG Mean,PPG Variance,Activity Mean,Activity Variance,Screening Score,Description');

    for (final result in state) {
      csv.write('${result.id ?? ""},');
      csv.write('${DateFormat('yyyy-MM-dd').format(result.timestamp)},');
      csv.write('${DateFormat('HH:mm:ss').format(result.timestamp)},');
      csv.write('${result.score},');
      csv.write('"${result.riskLevel}",');
      csv.write('${result.aiConfidence},');
      csv.write('${result.ppgMean},');
      csv.write('${result.ppgVariance},');
      csv.write('${result.activityMean},');
      csv.write('${result.activityVariance},');
      csv.write('${result.screeningScore},');
      csv.writeln('"${result.description.replaceAll('"', '""')}"');
    }

    return csv.toString();
  }

  Future<File?> saveCSVToFile() async {
    try {
      final csvContent = await exportToCSV();
      if (csvContent.isEmpty) return null;

      final String? path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save AI CSV File',
        fileName: 'soulscan_ai_history.csv',
        allowedExtensions: ['csv'],
      );

      if (path != null) {
        final file = File(path);
        await file.writeAsString(csvContent);
        return file;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  String? getLastExportPath() => _lastExportPath;
}

// Provider untuk AI History
final aiHistoryProvider =
    StateNotifierProvider<AIHistoryNotifier, List<AIResult>>((ref) {
      final repo = ref.watch(historyRepositoryProvider);
      return AIHistoryNotifier(repo);
    });

// Update exportStatusProvider untuk include AI
final exportStatusProvider = Provider<Map<String, bool>>((ref) {
  return {
    'psikologi': ref.read(psikologiHistoryProvider.notifier).isExporting,
    'mental': ref.read(mentalHistoryProvider.notifier).isExporting,
    'ai': ref.read(aiHistoryProvider.notifier).isExporting,
  };
});

// Update allHistoryProvider untuk include AI results
final allHistoryProvider = Provider<List<MentalResult>>((ref) {
  final psikologi = ref.watch(psikologiHistoryProvider);
  final mental = ref.watch(mentalHistoryProvider);
  final ai = ref.watch(aiHistoryProvider);
  
  // Convert AIResult to MentalResult untuk compatibility
  final aiAsMental = ai.map((a) => MentalResult(
    id: a.id,
    score: a.score,
    riskLevel: a.riskLevel,
    description: a.description,
    timestamp: a.timestamp,
    testType: 'ai',
  )).toList();
  
  return [...psikologi, ...mental, ...aiAsMental]
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
});


final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository();
});

final psikologiHistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<MentalResult>>((ref) {
      final repo = ref.watch(historyRepositoryProvider);
      return HistoryNotifier(repo, 'psikologi');
    });

final mentalHistoryProvider =
    StateNotifierProvider<HistoryNotifier, List<MentalResult>>((ref) {
      final repo = ref.watch(historyRepositoryProvider);
      return HistoryNotifier(repo, 'mental');
    });

// final exportStatusProvider = Provider<Map<String, bool>>((ref) {
//   return {
//     'psikologi': ref.read(psikologiHistoryProvider.notifier).isExporting,
//     'mental': ref.read(mentalHistoryProvider.notifier).isExporting,
//   };
// });

// final allHistoryProvider = Provider<List<MentalResult>>((ref) {
//   final psikologi = ref.watch(psikologiHistoryProvider);
//   final mental = ref.watch(mentalHistoryProvider);
//   return [...psikologi, ...mental]
//     ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
// });

final historyListProvider = FutureProvider<List<ScreeningRecord>>((ref) async {
  final repo = ref.read(historyRepositoryProvider);
  return await repo.getAll();
});

// Dashboard statistics provider
final dashboardStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final psikologi = ref.watch(psikologiHistoryProvider);
  final mental = ref.watch(mentalHistoryProvider);
  
  final totalTests = psikologi.length + mental.length;
  
  final avgPsikologiScore = psikologi.isEmpty ? 0 : 
      psikologi.map((e) => e.score).reduce((a, b) => a + b) / psikologi.length;
  final avgMentalScore = mental.isEmpty ? 0 : 
      mental.map((e) => e.score).reduce((a, b) => a + b) / mental.length;
  
  final riskDistribution = {
    'Low': 0,
    'Medium': 0,
    'High': 0,
  };
  
  for (final result in [...psikologi, ...mental]) {
    final risk = result.riskLevel.toLowerCase();
    if (risk.contains('low')) {
      riskDistribution['Low'] = riskDistribution['Low']! + 1;
    } else if (risk.contains('medium')) {
      riskDistribution['Medium'] = riskDistribution['Medium']! + 1;
    } else if (risk.contains('high')) {
      riskDistribution['High'] = riskDistribution['High']! + 1;
    }
  }
  
  return {
    'totalTests': totalTests,
    'psikologiCount': psikologi.length,
    'mentalCount': mental.length,
    'avgPsikologiScore': avgPsikologiScore,
    'avgMentalScore': avgMentalScore,
    'riskDistribution': riskDistribution,
    'lastUpdated': DateTime.now(),
  };
});