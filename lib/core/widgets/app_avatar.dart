import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

enum AppAvatarSize { small, medium, large }

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final AppAvatarSize size;

  const AppAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = AppAvatarSize.medium,
  });

  double get _radius => switch (size) {
        AppAvatarSize.small => 20,
        AppAvatarSize.medium => 32,
        AppAvatarSize.large => 48,
      };

  double get _fontSize => switch (size) {
        AppAvatarSize.small => 12,
        AppAvatarSize.medium => 16,
        AppAvatarSize.large => 22,
      };

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: _radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
        backgroundColor: AppColors.primaryLight,
      );
    }
    return CircleAvatar(
      radius: _radius,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        _initials,
        style: TextStyle(
          color: AppColors.primary,
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
