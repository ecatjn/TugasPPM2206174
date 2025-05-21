import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Controller 3 detik sama kayak timer splash screen
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Tween warna dari ungu tua ke ungu muda
    _colorAnimation = ColorTween(
      begin: Colors.deepPurple,      // ungu tua
      end: Colors.purple.shade200,  // ungu muda
    ).animate(_controller);

    // Mulai animasi warna
    _controller.forward();

    // Timer splash selesai, pindah ke OnboardingScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Konten utama: logo di tengah
          Center(
            child: Image.asset(
              'assets/group_9.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ),

          // Loading indicator di paling bawah dengan jarak 10 px dari bawah
          Positioned(
            left: 0,
            right: 0,
            bottom: 10, // 10 pixel dari bawah
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _colorAnimation,
                  builder: (context, child) {
                    return CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
                    );
                  },
                ),
                const SizedBox(height: 8),
                const Text(
                  "Memuat aplikasi...",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
