import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push(AppRoutes.editProfile),
          ),
        ],
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          ProfileStatus.loading || ProfileStatus.initial =>
            const AppInlineLoading(),
          ProfileStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: vm.loadProfile,
            ),
          _ => _ProfileContent(user: vm.user!),
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final dynamic user;

  const _ProfileContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 24),
          _ProfileStats(user: user),
          const SizedBox(height: 24),
          _MoreOptions(userId: user.id),
          const SizedBox(height: 16),
          _ProfileActions(),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final dynamic user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAvatar(
          imageUrl: user.profilePhotoUrl,
          name: user.displayName,
          size: AppAvatarSize.large,
        ),
        const SizedBox(height: 12),
        Text(
          user.displayName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 4),
        _RoleBadge(role: user.roleLabel),
      ],
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          role.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}

class _ProfileStats extends StatelessWidget {
  final dynamic user;

  const _ProfileStats({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: 'Rating',
              value: user.averageRating.toStringAsFixed(1),
              icon: Icons.star,
              color: AppColors.accentAmber,
            ),
            _StatItem(
              label: 'Teléfono',
              value: user.phone.isEmpty ? 'No registrado' : user.phone,
              icon: Icons.phone_outlined,
              color: AppColors.secondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ],
      );
}

class _MoreOptions extends StatelessWidget {
  final String userId;

  const _MoreOptions({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.history, color: AppColors.primary),
            title: const Text(AppStrings.tripHistory),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.tripHistory),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.star_outline, color: AppColors.accentAmber),
            title: const Text(AppStrings.myReviews),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(
              AppRoutes.userReviews.replaceFirst(':userId', userId),
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
            title: const Text(AppStrings.sos),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.sos),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.support_agent, color: AppColors.secondary),
            title: const Text(AppStrings.support),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.supportTickets),
          ),
        ],
      ),
    );
  }
}

class _ProfileActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _confirmLogout(context),
      icon: const Icon(Icons.logout, color: AppColors.error),
      label: const Text(
        AppStrings.logout,
        style: TextStyle(color: AppColors.error),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.error),
        minimumSize: const Size(double.infinity, 52),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.logoutConfirm),
        content: const Text(AppStrings.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              context.read<AuthViewModel>().logout();
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
