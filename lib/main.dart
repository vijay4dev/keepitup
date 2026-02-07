import 'package:flutter/material.dart';
import 'package:keepitup/screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        // 🌤️ Overall app background
        scaffoldBackgroundColor: Colors.white,

        // 🎨 Color scheme (NO PURPLE)
        colorScheme: const ColorScheme.light(
          primary: Colors.blue,      // buttons, highlights
          secondary: Colors.blue,
          surface: Colors.white,
          background: Colors.white,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),

        // 🧭 AppBar style
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

      ),

      home: const PdfListScreen(),
    );
  }
}
