import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/domain/entities/ai_result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../providers/history_providers.dart';
import '../../domain/entities/mental_result.dart';

const Color kPrimaryColor = Color(0xFF8A84FF);
const Color kSecondaryColor = Color(0xFFC7C3FF);
const Color kSuccessColor = Color(0xFF4CAF50);
const Color kWarningColor = Color(0xFFFF9800);
const Color kDangerColor = Color(0xFFF44336);
const Color kInfoColor = Color(0xFF2196F3);

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final psikologiHistory = ref.watch(psikologiHistoryProvider);
    final mentalHistory = ref.watch(mentalHistoryProvider);
    final allHistory = ref.watch(allHistoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            expandedHeight: 120.h,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  Image.asset('assets/img/logonotext.png', width: 30.w),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SoulScan',
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Dashboard',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  ref.refresh(psikologiHistoryProvider);
                  ref.refresh(mentalHistoryProvider);
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  
                  // Score Progress
                  _buildScoreProgress(allHistory),
                  SizedBox(height: 20.h),
                  
                  // Recent Activity
                  _buildRecentActivity(allHistory),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCircle({
    required String value,
    required String label,
    required String subtitle,
    required Color color,
    required Color bgColor,
  }) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, size: 20.w, color: iconColor),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int count) {
    return Column(
      children: [
        Container(
          width: 16.w,
          height: 16.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          '$count',
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreProgress(List<MentalResult> allHistory) {
    if (allHistory.length < 2) {
      return Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 15.r,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Score Progress',
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  Icon(Icons.timeline, size: 60.w, color: Colors.grey.shade300),
                  SizedBox(height: 12.h),
                  Text(
                    'Need more tests to show progress',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Ambil 5 data terakhir
    final recentTests = allHistory.take(5).toList();
    final recentScores = recentTests.map((e) => e.score).toList();
    
    // Hitung statistik
    final avgScore = recentScores.reduce((a, b) => a + b) / recentScores.length;
    final maxScore = recentScores.reduce((a, b) => a > b ? a : b);
    final minScore = recentScores.reduce((a, b) => a < b ? a : b);
    final improvement = recentScores.last - recentScores.first;

    // Siapkan data untuk line chart
    final lineChartData = LineChartBarData(
      spots: recentScores.asMap().entries.map((entry) {
        return FlSpot(entry.key.toDouble(), entry.value.toDouble());
      }).toList(),
      isCurved: true,
      color: kPrimaryColor,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(
        show: true,
        color: kPrimaryColor.withOpacity(0.1),
      ),
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 4,
            color: kPrimaryColor,
            strokeWidth: 2,
            strokeColor: Colors.white,
          );
        },
      ),
    );

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Score Progress (Last 5 Tests)',
            style: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            height: 180.h,
            child: LineChart(
              LineChartData(
                lineBarsData: [lineChartData],
                minX: 0,
                maxX: (recentScores.length - 1).toDouble(),
                minY: (minScore * 0.8).toDouble(), // Beri sedikit ruang di bawah
                maxY: (maxScore * 1.2).toDouble(), // Beri sedikit ruang di atas
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < recentTests.length) {
                          final date = recentTests[index].timestamp;
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              DateFormat('dd/MM').format(date),
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 10.sp,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildProgressStat(
                label: 'Average',
                value: avgScore.toStringAsFixed(1),
                icon: Icons.bar_chart,
              ),
              _buildProgressStat(
                label: 'Improvement',
                value: '${improvement > 0 ? '+' : ''}${improvement.toStringAsFixed(1)}',
                icon: improvement > 0 ? Icons.trending_up : Icons.trending_down,
                color: improvement > 0 ? kSuccessColor : kDangerColor,
              ),
              _buildProgressStat(
                label: 'Last Score',
                value: recentScores.last.toString(),
                icon: Icons.score,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat({
    required String label,
    required String value,
    required IconData icon,
    Color? color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: (color ?? kPrimaryColor).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 18.w,
            color: color ?? kPrimaryColor,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10.sp,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivity(List<MentalResult> allHistory) {
    final recentTests = allHistory.take(3).toList();

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Last 3 Tests',
                  style: GoogleFonts.poppins(
                    fontSize: 10.sp,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (recentTests.isEmpty)
            Center(
              child: Column(
                children: [
                  Icon(Icons.history, size: 60.w, color: Colors.grey.shade300),
                  SizedBox(height: 12.h),
                  Text(
                    'No recent activity',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            )
          else
            ...recentTests.map((result) {
              return Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: _buildActivityItem(result),
              );
            }).toList(),
        ],
      ),
    );
  }

  // Di dalam _buildActivityItem, tambahkan penanganan khusus untuk AI:
Widget _buildActivityItem(dynamic result) {
  final isAIResult = result is AIResult;
  final score = result.score;
  final riskLevel = result.riskLevel;
  final description = result.description;
  final timestamp = result.timestamp;
  final testType = isAIResult ? 'AI Analysis' : result.testType;
  
  // Untuk AI, tambahkan confidence indicator
  String? confidenceText;
  if (isAIResult) {
    confidenceText = '${(result.aiConfidence * 100).toStringAsFixed(0)}% conf';
  }
  
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16.r),
    ),
    child: Row(
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: _getRiskColor(riskLevel).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Center(
            child: Icon(
              _getRiskIcon(riskLevel),
              color: _getRiskColor(riskLevel),
              size: 20.w,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    testType.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: _getRiskColor(riskLevel).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.score,
                              size: 10.w,
                              color: _getRiskColor(riskLevel),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '$score',
                              style: GoogleFonts.poppins(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: _getRiskColor(riskLevel),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (confidenceText != null) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            confidenceText,
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              color: kPrimaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('MMM dd, HH:mm').format(timestamp),
                style: GoogleFonts.poppins(
                  fontSize: 10.sp,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                description.length > 60
                    ? '${description.substring(0, 60)}...'
                    : description,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: Colors.grey.shade700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (isAIResult) ...[
                SizedBox(height: 6.h),
                Wrap(
                  spacing: 6.w,
                  children: [
                    _buildAITag('PPG: ${result.ppgMean.toStringAsFixed(2)}'),
                    _buildAITag('Activity: ${result.activityMean.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildAITag(String text) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
    decoration: BoxDecoration(
      color: kInfoColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 8.sp,
        color: kInfoColor,
      ),
    ),
  );
}

  int _countRiskLevel(List<MentalResult> history, String level) {
    return history.where((result) {
      return result.riskLevel.toLowerCase().contains(level);
    }).length;
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return kSuccessColor;
      case 'medium':
        return kWarningColor;
      case 'high':
        return kDangerColor;
      default:
        return kPrimaryColor;
    }
  }

  IconData _getRiskIcon(String riskLevel) {
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
}