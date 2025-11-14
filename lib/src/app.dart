import 'package:flutter/material.dart';
// import 'package:flutter_project_pam/feature/insightmind/presentation/pages/home_page.dart';
import 'package:flutter_project_pam/src/views/splash.dart';
// import 'views/features/insightmind/presentation/pages/home_page.dart';

class InsightMindApp extends StatelessWidget {
  const InsightMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InsightMind',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HompSplashMe(),
    );
  }
}
