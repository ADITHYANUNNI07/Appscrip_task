import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_manager/core/utils/color/color.dart';
import 'package:task_manager/db/database_sqflite.dart';
import 'package:task_manager/presentation/splash/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabase();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: colorWhite,
        colorScheme: ColorScheme.fromSeed(seedColor: colorApp),
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const SplashScrn(),
    );
  }
}
