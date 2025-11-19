import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/history_providers.dart';
import '../../domain/entities/mental_result.dart';
import 'history_detail_page.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

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
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: kHistoryPageBackgroundColor,
      floatingActionButton: Consumer(
        builder: (context, ref, child) {
          final provider = _currentTabIndex == 0 
              ? psikologiHistoryProvider 
              : mentalHistoryProvider;
              
          final historyList = ref.watch(provider);
        
          if (historyList.isEmpty) {
            return const SizedBox.shrink();
          }
          
          return FloatingActionButton(
            onPressed: () {
              _showDeleteAllDialog(context, ref, provider, _currentTabIndex);
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
                _buildSubtitle(context),
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
                              Tab(text: 'Tes Psikologi'),
                              Tab(text: 'Tes Mental'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              HistoryListTab(
                                provider: psikologiHistoryProvider,
                                type: HistoryType.psikologi,
                              ),
                              HistoryListTab(
                                provider: mentalHistoryProvider,
                                type: HistoryType.mental,
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
          ],
        ),
      ),
    );
  }

  void _showDeleteAllDialog(
    BuildContext context, 
    WidgetRef ref, 
    StateNotifierProvider<HistoryNotifier, List<MentalResult>> provider,
    int currentTabIndex
  ) {
    final tabName = currentTabIndex == 0 ? 'Psikologi' : 'Mental';
    
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
              ref.read(provider.notifier).clearHistory();
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

  Widget _buildSubtitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text(
              'Yukk Jaga Kesehatan Mental dan Sikologi kalian',
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
        ],
      ),
    );
  }
}
enum HistoryType { psikologi, mental }

class HistoryListTab extends ConsumerWidget {
  final StateNotifierProvider<HistoryNotifier, List<MentalResult>> provider;
  final HistoryType type;

  const HistoryListTab({super.key, required this.provider, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<MentalResult> historyList = ref.watch(provider);

    if (historyList.isEmpty) {
      return Center(
        child: Text(
          'No history found.',
          style: TextStyle(color: Colors.black54, fontSize: 14.sp),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: historyList.length,
      itemBuilder: (context, index) {
        final MentalResult result = historyList[index];

        if (type == HistoryType.psikologi) {
          return HistoryCardPsikologi(result: result, provider: provider);
        } else {
          return HistoryCardMental(result: result, provider: provider);
        }
      },
    );
  }
}

class HistoryCardPsikologi extends ConsumerWidget {
  final MentalResult result;
  final StateNotifierProvider<HistoryNotifier, List<MentalResult>> provider;
  
  const HistoryCardPsikologi({
    super.key, 
    required this.result, 
    required this.provider
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Image.asset('assets/img/logoOtak.png', width: 60.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tes Psikologi',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Hapus Riwayat'),
                              content: const Text(
                                'Apakah Anda yakin ingin menghapus riwayat ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(provider.notifier).removeResultFromHistory(result);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    result.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailPage(
                            title: 'History Psikologi',
                            result: result,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB7C5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Lihat History Tes',
                      style: GoogleFonts.poppins(fontSize: 12.sp),
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

class HistoryCardMental extends ConsumerWidget {
  final MentalResult result;
  final StateNotifierProvider<HistoryNotifier, List<MentalResult>> provider;
  
  const HistoryCardMental({
    super.key, 
    required this.result, 
    required this.provider
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          children: [
            Image.asset('assets/img/logoMental.png', width: 60.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tes Kesehatan Mental',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text('Hapus Riwayat'),
                              content: const Text(
                                'Apakah Anda yakin ingin menghapus riwayat ini?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(provider.notifier).removeResultFromHistory(result);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    result.description,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoryDetailPage(
                            title: 'History Mental',
                            result: result,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA8E6CF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Lihat History Tes',
                      style: GoogleFonts.poppins(fontSize: 12.sp),
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