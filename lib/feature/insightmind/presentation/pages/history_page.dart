import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/history_providers.dart';
import '../../data/local/screening_record.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text('History')
          ],
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF8A84FF),
      ),
      body: historyAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final ScreeningRecord r = items[i];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.shade100,
                    child: Text(
                      r.score.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                  title: Text(
                    'Risiko: ${r.riskLevel}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    'Waktu: ${r.timestamp}\nID: ${r.id}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await ref
                          .read(historyRepositoryProvider)
                          .deleteById(r.id);
                      ref.refresh(historyListProvider);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Riwayat dihapus'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.teal)),
        error: (e, _) => Center(
          child: Text('Terjadi kesalahan: $e'),
        ),
      ),
      
      floatingActionButton: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FilledButton.icon(
          icon: const Icon(Icons.delete_sweep),
          label: const Text('Hapus'),
          style: FilledButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
          ),
          onPressed: () async {
            final ok = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Konfirmasi'),
                content:
                    const Text('Yakin ingin menghapus semua riwayat?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Batal'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Hapus'),
                  ),
                ],
              ),
            );

            if (ok == true) {
              await ref.read(historyRepositoryProvider).clearAll();
              ref.refresh(historyListProvider);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua riwayat telah dihapus')),
              );
            }
          },
        ),
      ),
    );
  }
}
