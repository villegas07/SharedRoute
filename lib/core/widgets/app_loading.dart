import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppFullScreenLoading extends StatelessWidget {
  const AppFullScreenLoading({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: _PulsingLoader(),
      );
}

class AppInlineLoading extends StatelessWidget {
  const AppInlineLoading({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: _PulsingLoader()),
      );
}

class _PulsingLoader extends StatefulWidget {
  const _PulsingLoader();

  @override
  State<_PulsingLoader> createState() => _PulsingLoaderState();
}

class _PulsingLoaderState extends State<_PulsingLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, _buildDot),
      ),
    );
  }

  Widget _buildDot(int index) {
    final delay = index * 0.2;
    final value = (_animation.value - delay).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3 + value * 0.7),
        shape: BoxShape.circle,
      ),
      transform: Matrix4.translationValues(0, -6 * value, 0),
    );
  }
}
