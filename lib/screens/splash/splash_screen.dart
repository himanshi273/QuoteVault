import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../home/home_screen.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 3));

    final session = Supabase.instance.client.auth.currentSession;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
        session != null ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF4F7FF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF5B5FFF),
                    Color(0xFF00C6A7),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 48,
              ),
            ),

            const SizedBox(height: 24),

            // Title
            RichText(
              text: TextSpan(
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                children: const [
                  TextSpan(text: 'Quote', style: TextStyle(color: Color(0xFF5B5FFF))),
                  TextSpan(text: 'Vault', style: TextStyle(color: Color(0xFF00C6A7))),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Inspire Every Day',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 32),

            // Gradient Loader
            SizedBox(
              width: 80,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) {
                  return LinearProgressIndicator(
                    value: _controller.value,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF5B5FFF),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
