import 'package:flutter/material.dart';
import '../utils/theme.dart';

class NeonButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const NeonButton({super.key, required this.text, required this.onTap, this.color = AppTheme.primaryNeon});

  @override
  State<NeonButton> createState() => _NeonButtonState();
}

class _NeonButtonState extends State<NeonButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          decoration: BoxDecoration(
            color: AppTheme.bgLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.color.withOpacity(0.8), width: 2),
            boxShadow: [
              BoxShadow(color: widget.color.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 4)),
              BoxShadow(color: widget.color.withOpacity(0.2), blurRadius: 30, spreadRadius: 2),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: AppTheme.neonFont.copyWith(
                color: widget.color,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}