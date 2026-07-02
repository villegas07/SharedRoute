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
        AppAvatarSize.large => 50,
      };

  double get _fontSize => switch (size) {
        AppAvatarSize.small => 12,
        AppAvatarSize.medium => 16,
        AppAvatarSize.large => 22,
      };

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
  }

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  LinearGradient get _gradient => const LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: _gradient),
      child: _hasImage ? _imageAvatar() : _initialsAvatar(),
    );
  }

  Widget _imageAvatar() => CircleAvatar(
        radius: _radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
        backgroundColor: AppColors.backgroundAlt,
      );

  Widget _initialsAvatar() => CircleAvatar(
        radius: _radius,
        backgroundColor: AppColors.primaryLight,
        child: Text(
          _initials,
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: _fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
