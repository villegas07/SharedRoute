import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating;
  final double size;
  final ValueChanged<int>? onChanged;

  const StarRatingWidget({
    super.key,
    required this.rating,
    this.size = 32,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        return GestureDetector(
          onTap: onChanged != null ? () => onChanged!(starValue) : null,
          child: Icon(
            starValue <= rating ? Icons.star : Icons.star_border,
            color: AppColors.warning,
            size: size,
          ),
        );
      }),
    );
  }
}
