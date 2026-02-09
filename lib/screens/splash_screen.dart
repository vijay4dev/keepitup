import 'dart:io';
import 'package:flutter/material.dart';
import 'package:keepitup/screens/homescreen.dart';
import 'package:keepitup/services/navigation_service.dart';
import 'package:keepitup/services/pdf_scanne_services.dart';
import 'package:keepitup/services/permission_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startFlow();
  }

  void _setupAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _rotationAnimation = Tween<double>(begin: -0.15, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  Future<void> _startFlow() async {
    // animation + init parallel
    await Future.wait([
      _controller.forward(),
      _initApp(),
    ]);
  }

  Future<void> _initApp() async {
    final granted = await PermissionService.requestStorage();

    if (!granted) {
      _goHome([], true);
      return;
    }

    final pdfs = await PdfScanService.scanAllPdfs();
    _goHome(pdfs, false);
  }

  void _goHome(List<File> files, bool permissionDenied) {
    if (!mounted) return;
    NavigationService.pushReplacement(PdfListScreen(initialPdfs: files, permissionDenied: permissionDenied));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xffEFF6FF),
                    Color(0xffF3E8FF),
                    Color.fromARGB(255, 252, 239, 246),
                  ],
                ),
              ),
            ),
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RotationTransition(
                      turns: _rotationAnimation,
                      child: Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xff3B82F6),
                              Color(0xff7C3AED),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.description_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SlideTransition(
                      position: _slideAnimation,
                      child: const Column(
                        children: [
                          Text(
                            "Keep It",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Find documents by content, not folders",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
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
      ),
    );
  }
}
