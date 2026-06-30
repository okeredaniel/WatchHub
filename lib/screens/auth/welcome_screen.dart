import 'package:flutter/material.dart';
import '../../app_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Brand logo
              Column(
                children: [
                  Text(
                    'WATCHHUB',
                    style: TextStyle(
                      fontFamily: 'Newake',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Text(
                    'LUXURY TIMEPIECES',
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 1,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Hero watch image with floating dots
              SizedBox(
                height: 600,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      left: 30,
                      child: _dot(Colors.tealAccent, 8),
                    ),
                    Positioned(
                      top: 0,
                      right: 50,
                      child: _dot(Colors.deepOrangeAccent, 6),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 10,
                      child: _dot(Colors.grey.shade300, 6),
                    ),
                    Image.asset(
                      'assets/images/Watches.png',
                      height: 600,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Headline
              const Text(
                'TOP BRANDS WATCH\nFOR THE REAL GENTLEMAN',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Newake',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  height: 1,
                  letterSpacing: 0.4,
                ),
              ),

              const SizedBox(height: 15),

              // CTA button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.login);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}