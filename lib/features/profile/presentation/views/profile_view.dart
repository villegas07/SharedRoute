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
      body: Consumer<ProfileViewModel>(builder: _buildState),
    );
  }

  Widget _buildState(BuildContext context, ProfileViewModel vm, Widget? child) {
    return switch (vm.status) {
      ProfileStatus.loading || ProfileStatus.initial => const AppInlineLoading(),
      ProfileStatus.error => AppErrorState(
          message: vm.errorMessage ?? AppStrings.errorOccurred,
          onRetry: vm.loadProfile,
        ),
      _ => _ProfileBody(user: vm.user!),
    };
  }
}

class _ProfileBody extends StatelessWidget {
  final UserEntity user;

  const _ProfileBody({required this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ProfileHeader(user: user)),
        const _SliverGap(24),
        SliverToBoxAdapter(child: _StatsRow(user: user)),
        const _SliverGap(24),
        SliverToBoxAdapter(child: _MenuSection(user: user)),
        const _SliverGap(24),
        const SliverToBoxAdapter(child: _LogoutButton()),
        const _SliverGap(40),
      ],
    );
  }
}

class _SliverGap extends StatelessWidget {
  final double height;

  const _SliverGap(this.height);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: height));
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        bottom: false,
        child: _HeaderContent(user: user),
      ),
    );
  }
}

class _HeaderContent extends StatelessWidget {
  final UserEntity user;

  const _HeaderContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAvatar(
          imageUrl: user.profilePhotoUrl,
          name: user.displayName,
          size: AppAvatarSize.large,
        ),
        const SizedBox(height: 16),
        _HeaderIdentity(user: user),
        const SizedBox(height: 12),
        _StatusBadge(status: user.roleLabel),
      ],
    );
  }
}

class _HeaderIdentity extends StatelessWidget {
  final UserEntity user;

  const _HeaderIdentity({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          user.displayName,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          user.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _CardSurface(child: _StatsContent(user: user)),
    );
  }
}

class _StatsContent extends StatelessWidget {
  final UserEntity user;

  const _StatsContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            icon: Icons.star_rounded,
            color: AppColors.accentAmber,
            value: user.averageRating.toStringAsFixed(1),
            label: 'Rating',
          ),
        ),
        const _StatDivider(),
        Expanded(child: _PhoneStat(user: user)),
        const _StatDivider(),
        Expanded(child: _VerifiedStat(user: user)),
      ],
    );
  }
}

class _PhoneStat extends StatelessWidget {
  final UserEntity user;

  const _PhoneStat({required this.user});

  @override
  Widget build(BuildContext context) {
    return _StatItem(
      icon: Icons.phone_rounded,
      color: AppColors.secondary,
      value: user.phone.isNotEmpty ? '✓' : '—',
      label: 'Teléfono',
    );
  }
}

class _VerifiedStat extends StatelessWidget {
  final UserEntity user;

  const _VerifiedStat({required this.user});

  @override
  Widget build(BuildContext context) {
    return _StatItem(
      icon: Icons.verified_rounded,
      color: AppColors.success,
      value: user.status == UserStatus.active ? '✓' : '—',
      label: 'Verificado',
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.backgroundAlt);
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 6),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _MenuSection extends StatelessWidget {
  final UserEntity user;

  const _MenuSection({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: _CardSurface(child: _MenuContent(user: user)),
    );
  }
}

class _MenuContent extends StatelessWidget {
  final UserEntity user;

  const _MenuContent({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MenuItem(
          icon: Icons.history_rounded,
          label: 'Historial de viajes',
          onTap: () => context.push(AppRoutes.tripHistory),
        ),
        const _MenuDivider(),
        _MenuItem(
          icon: Icons.star_outline_rounded,
          label: 'Mis reseñas',
          onTap: () => context.push(_reviewRoute(user.id)),
        ),
        const _MenuDivider(),
        _MenuItem(
          icon: Icons.shield_outlined,
          label: 'Emergencia SOS',
          iconColor: AppColors.accentCoral,
          onTap: () => context.push(AppRoutes.sos),
        ),
        const _MenuDivider(),
        _MenuItem(
          icon: Icons.headset_mic_outlined,
          label: 'Soporte',
          onTap: () => context.push(AppRoutes.supportTickets),
        ),
      ],
    );
  }

  String _reviewRoute(String userId) {
    return AppRoutes.userReviews.replaceFirst(':userId', userId);
  }
}

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 56);
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: _MenuIcon(icon: icon, color: iconColor ?? AppColors.primary),
      title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textDisabled,
      ),
    );
  }
}

class _MenuIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _MenuIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _CardSurface extends StatelessWidget {
  final Widget child;

  const _CardSurface({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, 4),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        style: _buttonStyle(),
        icon: const Icon(Icons.logout_rounded),
        label: const Text(AppStrings.logout),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return OutlinedButton.styleFrom(
      foregroundColor: AppColors.accentCoral,
      side: BorderSide(color: AppColors.accentCoral.withValues(alpha: 0.3)),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (_) => const _LogoutDialog(),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<AuthViewModel>().logout();
      }
    });
  }
}

class _LogoutDialog extends StatelessWidget {
  const _LogoutDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cerrar sesión'),
      content: const Text('¿Estás seguro de que deseas salir?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Salir'),
        ),
      ],
    );
  }
}
