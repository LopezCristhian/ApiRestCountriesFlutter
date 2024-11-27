import 'package:flutter/material.dart';
import 'splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //debugShowCheckedModeBanner: false,
      title: 'Países del mundo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.teal.shade400,
          secondary: Colors.tealAccent,
          //background: const Color(0xFF1A1A2E),
          surface: const Color(0xFF16213E),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF16213E),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

void main() {
  runApp(const MyApp());
}
