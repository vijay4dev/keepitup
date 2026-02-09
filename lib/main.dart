import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keepitup/screens/homescreen.dart';
import 'package:keepitup/screens/splash_screen.dart';
import 'package:keepitup/services/navigation_service.dart';
import 'package:keepitup/services/permission_service.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await WakelockPlus.enable();
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
          primary: Colors.blue, // buttons, highlights
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
      navigatorKey: NavigationService.navigatorKey,
      home: SplashScreen()
    );
  }
}
