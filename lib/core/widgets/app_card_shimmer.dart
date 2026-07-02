import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppCardShimmer extends StatefulWidget {
  final int count;

  const AppCardShimmer({super.key, this.count = 3});

  @override
  State<AppCardShimmer> createState() => _AppCardShimmerState();
}

class _AppCardShimmerState extends State<AppCardShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Column(
        children: List.generate(widget.count, _buildCard),
      ),
    );
  }

  Widget _buildCard(int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: _shimmerGradient(),
        ),
      ),
    );
  }

  LinearGradient _shimmerGradient() {
    final position = _ctrl.value;
    return LinearGradient(
      begin: Alignment(-1.0 + 2 * position, 0),
      end: Alignment(1.0 + 2 * position, 0),
      colors: const [
        AppColors.backgroundAlt,
        AppColors.backgroundWhite,
        AppColors.backgroundAlt,
      ],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}
