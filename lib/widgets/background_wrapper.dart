import 'package:flutter/material.dart';
import '../utils/theme.dart';

class BackgroundWrapper extends StatelessWidget {
  final Widget child;
  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // In a real app, use a Lottie.asset('assets/lottie/particles.json') here
    // or a CustomPainter for dynamic particles.
    // Using a glowing gradient mesh for simplicity in this code block.
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.bgDark, Color(0xFF0D0221), AppTheme.bgDark],
          stops: [0.2, 0.5, 0.9],
        ),
      ),
      child: Stack(
        children: [
          // Placeholder for particle effect
          Positioned(
            top: -100, left: -100,
            child: Container(
              width: 300, height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryNeon.withOpacity(0.05),
                boxShadow: [BoxShadow(color: AppTheme.primaryNeon.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),
           Positioned(
            bottom: -50, right: -50,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.secondaryNeon.withOpacity(0.05),
                 boxShadow: [BoxShadow(color: AppTheme.secondaryNeon.withOpacity(0.1), blurRadius: 100, spreadRadius: 50)],
              ),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}