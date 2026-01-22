import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import './feature/insightmind/data/local/screening_record.dart';
import './feature/insightmind/data/local/penilaian.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Hive.initFlutter();
  Hive.registerAdapter(ScreeningRecordAdapter());
  Hive.registerAdapter(PenilaianAdapter());
  
  // Clear corrupted cache
  try {
    await Hive.deleteBoxFromDisk('screening_records');
  } catch (e) {
    // Box doesn't exist yet, that's fine
  }
  
  await Hive.openBox<ScreeningRecord>('screening_records');
  await Hive.openBox<Penilaian>('penilaian_history');
  runApp(const ProviderScope(child: InsightMindApp()));
}