// WEEK7 - UI Prediksi AI modern
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_project_pam/feature/insightmind/data/models/feature_vector.dart';
import '../providers/ai_provider.dart';

class AIResultPage extends StatelessWidget {
  final FeatureVector fv;
  final Map<String, dynamic> aiResult;
  
  const AIResultPage({
    super.key,
    required this.fv,
    required this.aiResult,
  });
  
  @override
  Widget build(BuildContext context) {
    final score = aiResult['score'] ?? 0;
    final riskLevel = aiResult['riskLevel'] ?? 'Unknown';
    final confidence = (aiResult['confidence'] ?? 0.0).toDouble();
    final recommendations = (aiResult['recommendations'] as List<String>?) ?? [];
    
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FF),
      appBar: AppBar(
        title: Text(
          'AI Analysis Result',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Color(0xFF8A84FF),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Main Score Card
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF8A84FF),
                      Color(0xFF6C63FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF8A84FF).withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Score Display
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$score',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'AI Score',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            Text(
                              '/100',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    
                    // Risk Level & Confidence
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _getRiskColor(riskLevel).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _getRiskColor(riskLevel).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getRiskIcon(riskLevel),
                                          size: 16,
                                          color: _getRiskColor(riskLevel),
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          riskLevel.toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _getRiskColor(riskLevel),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_outlined,
                                    size: 18,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    '${(confidence * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Confidence Level',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              
              // Feature Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     Row(
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            color: Color(0xFF8A84FF),
                            size: 24,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Feature Details',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      
                      // Feature Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: [
                          _buildFeatureTile(
                            'Screening Score',
                            '${fv.screeningScore.toStringAsFixed(1)}',
                            Icons.score_outlined,
                            Color(0xFF8A84FF),
                          ),
                          _buildFeatureTile(
                            'PPG Mean',
                            '${fv.ppgMean.toStringAsFixed(4)}',
                            Icons.heart_broken_outlined,
                            Color(0xFFEF476F),
                          ),
                          _buildFeatureTile(
                            'PPG Variance',
                            '${fv.ppgVar.toStringAsFixed(6)}',
                            Icons.trending_up_outlined,
                            Color(0xFFFFD166),
                          ),
                          _buildFeatureTile(
                            'Activity Mean',
                            '${fv.activityMean.toStringAsFixed(4)}',
                            Icons.directions_run_outlined,
                            Color(0xFF06D6A0),
                          ),
                          _buildFeatureTile(
                            'Activity Variance',
                            '${fv.activityVar.toStringAsFixed(6)}',
                            Icons.show_chart_outlined,
                            Color(0xFF118AB2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Recommendations Card
              if (recommendations.isNotEmpty)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: Color(0xFFFFD166),
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Recommendations',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        
                        ...recommendations.asMap().entries.map((entry) {
                          final index = entry.key;
                          final rec = entry.value;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF8A84FF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF8A84FF),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      rec,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade800,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              
              SizedBox(height: 20),
              
              // Action Buttons
              // Row(
              //   children: [
              //     Expanded(
              //       child: OutlinedButton.icon(
              //         onPressed: () {
              //           Navigator.pop(context);
              //         },
              //         style: OutlinedButton.styleFrom(
              //           padding: EdgeInsets.symmetric(vertical: 16),
              //           side: BorderSide(color: Color(0xFF8A84FF)),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //         ),
              //         icon: Icon(
              //           Icons.arrow_back,
              //           color: Color(0xFF8A84FF),
              //         ),
              //         label: Text(
              //           'Back',
              //           style: TextStyle(
              //             color: Color(0xFF8A84FF),
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 12),
              //     Expanded(
              //       child: ElevatedButton.icon(
              //         onPressed: () {
              //           // TODO: Save action
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Color(0xFF8A84FF),
              //           foregroundColor: Colors.white,
              //           padding: EdgeInsets.symmetric(vertical: 16),
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(12),
              //           ),
              //         ),
              //         icon: Icon(Icons.save_alt_outlined),
              //         label: Text(
              //           'Save',
              //           style: TextStyle(
              //             fontWeight: FontWeight.w500,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildFeatureTile(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low': return Color(0xFF06D6A0);
      case 'medium': return Color(0xFFFFD166);
      case 'high': return Color(0xFFEF476A);
      default: return Colors.grey;
    }
  }
  
  IconData _getRiskIcon(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'low': return Icons.sentiment_very_satisfied;
      case 'medium': return Icons.sentiment_neutral;
      case 'high': return Icons.sentiment_very_dissatisfied;
      default: return Icons.help_outline;
    }
  }
}