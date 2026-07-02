import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../auth/domain/entities/user_entity.dart';
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
      backgroundColor: AppColors.background,
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          ProfileStatus.loading ||
          ProfileStatus.initial => const AppInlineLoading(),
          ProfileStatus.error => AppErrorState(
            message: vm.errorMessage ?? AppStrings.errorOccurred,
            onRetry: vm.loadProfile,
          ),
          _ => _ProfileBody(user: vm.user!),
        },
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  final UserEntity user;

  const _ProfileBody({required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ProfileHeader(user: user),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                _StatsRow(user: user),
                const SizedBox(height: 18),
                _ContactCard(user: user),
                const SizedBox(height: 18),
                _SectionCard(
                  title: 'Actividad',
                  children: [
                    _MenuItem(
                      icon: Icons.history_rounded,
                      label: AppStrings.tripHistory,
                      color: AppColors.primary,
                      onTap: () => context.push(AppRoutes.tripHistory),
                    ),
                    _MenuItem(
                      icon: Icons.star_outline_rounded,
                      label: AppStrings.myReviews,
                      color: AppColors.accentAmber,
                      onTap: () => context.push(
                        AppRoutes.userReviews.replaceFirst(':userId', user.id),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _SectionCard(
                  title: 'Ayuda y seguridad',
                  children: [
                    _MenuItem(
                      icon: Icons.sos_rounded,
                      label: AppStrings.sos,
                      color: AppColors.accentCoral,
                      onTap: () => context.push(AppRoutes.sos),
                    ),
                    _MenuItem(
                      icon: Icons.support_agent_rounded,
                      label: AppStrings.support,
                      color: AppColors.secondary,
                      onTap: () => context.push(AppRoutes.supportTickets),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _LogoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topInset + 12, 20, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
      ),
      child: Column(
        children: [
          _HeaderBar(onEdit: () => context.push(AppRoutes.editProfile)),
          const SizedBox(height: 18),
          _AvatarFrame(user: user),
          const SizedBox(height: 14),
          _HeaderName(user: user),
          const SizedBox(height: 6),
          _HeaderEmail(user: user),
          const SizedBox(height: 12),
          _RoleBadge(role: user.roleLabel),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  final VoidCallback onEdit;

  const _HeaderBar({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Mi perfil',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        _HeaderIconButton(icon: Icons.edit_rounded, onTap: onEdit),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _AvatarFrame extends StatelessWidget {
  final UserEntity user;

  const _AvatarFrame({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: AppAvatar(
        imageUrl: user.profilePhotoUrl,
        name: user.displayName,
        size: AppAvatarSize.large,
      ),
    );
  }
}

class _HeaderName extends StatelessWidget {
  final UserEntity user;

  const _HeaderName({required this.user});

  @override
  Widget build(BuildContext context) {
    return Text(
      user.displayName,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _HeaderEmail extends StatelessWidget {
  final UserEntity user;

  const _HeaderEmail({required this.user});

  @override
  Widget build(BuildContext context) {
    return Text(
      user.email,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Colors.white.withValues(alpha: 0.82),
      ),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        role,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final UserEntity user;

  const _StatsRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.star_rounded,
              value: user.averageRating.toStringAsFixed(1),
              label: AppStrings.rating,
              color: AppColors.accentAmber,
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.badge_rounded,
              value: user.roleLabel,
              label: 'Perfil',
              color: AppColors.primary,
            ),
          ),
          const _StatDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.calendar_month_rounded,
              value: _memberYear(user.createdAt),
              label: 'Desde',
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  String _memberYear(String value) {
    if (value.length >= 4) return value.substring(0, 4);
    return '—';
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 44,
      color: AppColors.backgroundAlt,
      margin: const EdgeInsets.symmetric(horizontal: 6),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final UserEntity user;

  const _ContactCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        children: [
          _CardTitle(title: 'Información personal'),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.mail_outline_rounded,
            label: AppStrings.email,
            value: user.email,
          ),
          const SizedBox(height: 14),
          _InfoRow(
            icon: Icons.phone_rounded,
            label: AppStrings.phone,
            value: user.phone.isEmpty ? 'No registrado' : user.phone,
          ),
        ],
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String title;

  const _CardTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _InfoIcon(icon: icon),
        const SizedBox(width: 12),
        Expanded(
          child: _InfoText(label: label, value: value),
        ),
      ],
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;

  const _InfoIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}

class _InfoText extends StatelessWidget {
  final String label;
  final String value;

  const _InfoText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return _SurfaceCard(
      child: Column(
        children: [
          _CardTitle(title: title),
          const SizedBox(height: 10),
          ..._withDividers(children),
        ],
      ),
    );
  }

  List<Widget> _withDividers(List<Widget> items) {
    return items.asMap().entries.expand((entry) {
      final isLast = entry.key == items.length - 1;
      final divider = const Divider(height: 1, indent: 54);
      return isLast ? [entry.value] : [entry.value, divider];
    }).toList();
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textDisabled,
      ),
      onTap: onTap,
    );
  }
}

class _SurfaceCard extends StatelessWidget {
  final Widget child;

  const _SurfaceCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout_rounded, color: AppColors.error),
        label: const Text(
          AppStrings.logout,
          style: TextStyle(color: AppColors.error),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.accentCoralLight),
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.backgroundWhite,
        ),
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
