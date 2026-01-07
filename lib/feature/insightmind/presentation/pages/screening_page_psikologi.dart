import 'package:flutter/material.dart';
import 'package:flutter_project_pam/feature/insightmind/presentation/pages/history_detail_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/score_provider.dart';
import '../providers/history_providers.dart';

class ScreeningPage extends ConsumerWidget {
  const ScreeningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final qState = ref.watch(questionnaireProvider);

    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tes Psikologi'),
            Image.asset('assets/img/logonotext.png', width: 30.w),
          ],
        ),
        backgroundColor: Color(0xFF8A84FF),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ListView.separated(
                    controller: ScrollController(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => const Divider(height: 24),
                    itemBuilder: (context, index) {
                      final q = questions[index];
                      final selected = qState.answers[q.id];

                      return _QuestionTile(
                        question: q,
                        selectedScore: selected,
                        onSelected: (score) {
                          ref
                              .read(questionnaireProvider.notifier)
                              .selectAnswer(questionId: q.id, score: score);
                        },
                      );
                    },
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(10.r),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF8A84FF),
                        ),
                        elevation: MaterialStateProperty.all(5),
                      ),
                      onPressed: () {
                        if (!qState.isComplete) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Lengkapi semua pertanyaan dulu.'),
                            ),
                          );
                          return;
                        }

                        _showAnswersBeforeResult(
                          context,
                          ref,
                          questions,
                          qState,
                        );
                      },
                      child: Text(
                        'Selesai',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
      // bottomNavigationBar: SafeArea(
      //   minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Center(
      //         child: Text(
      //           '${qState.answers.length} / ${questions.length} Pertanyaan Terisi',
      //           style: const TextStyle(
      //             fontWeight: FontWeight.bold,
      //             fontSize: 16,
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 12),

      //       SizedBox(
      //         width: double.infinity,
      //         child: FilledButton(
      //           onPressed: () {
      //             if (!qState.isComplete) {
      //               ScaffoldMessenger.of(context).showSnackBar(
      //                 const SnackBar(
      //                   content: Text('Lengkapi semua pertanyaan dulu.'),
      //                 ),
      //               );
      //               return;
      //             }

      //             _showAnswersBeforeResult(context, ref, questions, qState);
      //           },
      //           child: const Text('Lihat Hasil'),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  void _showAnswersBeforeResult(
    BuildContext context,
    WidgetRef ref,
    List<Question> questions,
    dynamic qState,
  ) {
    final answered = questions
        .where((q) => qState.answers[q.id] != null)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF8A84FF),
        contentPadding: EdgeInsets.all(15.w),
        title: Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Jawaban Anda',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.close),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: answered.map((q) {
                final selectedOption = q.options.firstWhere(
                  (opt) => opt.score == qState.answers[q.id],
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${q.id}. ${q.text}",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Jawaban Anda: ${selectedOption.label}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 0.5),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          FilledButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Color(0xFF8A84FF)),
              elevation: MaterialStateProperty.all(5),
            ),
            // Di ScreeningPage psikologi, ubah bagian ini:
            onPressed: () {
              final answersOrdered = <int>[];
              for (final q in questions) {
                answersOrdered.add(qState.answers[q.id]!);
              }
              ref.read(answersProvider.notifier).state = answersOrdered;

              final result = ref.read(resultProvider);

              // Panggil addResultToHistory dengan parameter yang benar
              ref
                  .read(psikologiHistoryProvider.notifier)
                  .addResultToHistory(
                    score: result.score,
                    riskLevel: result.riskLevel,
                    description: result.description,
                    notes: result
                        .description, // atau tambahkan field notes di MentalResult
                  );

              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => HistoryDetailPage(
                    title: 'History Psikologi',
                    result: result,
                  ),
                ),
              );
            },
            child: Text('Selesai', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  final Question question;
  final int? selectedScore;
  final ValueChanged<int> onSelected;

  const _QuestionTile({
    required this.question,
    required this.selectedScore,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.text, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        for (final i in question.options)
          RadioListTile<int>(
            title: Text('${i.label}'),
            value: i.score,
            groupValue: selectedScore,
            onChanged: (index) => onSelected(index!),
          ),
      ],
    );
  }
}
