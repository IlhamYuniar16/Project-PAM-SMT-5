import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'src/app.dart';
import './feature/insightmind/data/local/screening_record.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "assets/.env");
  await Hive.initFlutter();
  Hive.registerAdapter(ScreeningRecordAdapter());
  await Hive.openBox<ScreeningRecord>('screening_records');
  runApp(const ProviderScope(child: InsightMindApp()));
}