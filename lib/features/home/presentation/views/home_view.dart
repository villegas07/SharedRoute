import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../../bookings/domain/entities/booking_entity.dart';
import '../../../bookings/presentation/viewmodels/bookings_list_viewmodel.dart';
import '../../../bookings/presentation/widgets/booking_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<BookingsListViewModel>().loadBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => context.read<BookingsListViewModel>().loadBookings(),
          child: const _HomeBody(),
        ),
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _HomeHero(),
          SizedBox(height: 20),
          _QuickSearchCard(),
          SizedBox(height: 24),
          _RecentBookingsSection(),
        ],
      ),
    );
  }
}

class _HomeHero extends StatelessWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [_heroShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroHeader(user?.displayName, user?.profilePhotoUrl),
          const SizedBox(height: 18),
          const _HeroPills(),
        ],
      ),
    );
  }

  BoxShadow _heroShadow() {
    return BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.24),
      blurRadius: 28,
      offset: const Offset(0, 14),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final String? name;
  final String? imageUrl;

  const _HeroHeader(this.name, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.homeGreeting}$_suffix 👋',
                style: theme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.homeSearchPrompt,
                style: theme.bodyLarge?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        AppAvatar(
          imageUrl: imageUrl,
          name: name ?? 'U',
          size: AppAvatarSize.medium,
        ),
      ],
    );
  }

  String get _suffix => name == null ? '' : ', $name';
}

class _HeroPills extends StatelessWidget {
  const _HeroPills();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _HeroPill(Icons.verified_user_rounded, 'Conductores verificados'),
        _HeroPill(Icons.flash_on_rounded, 'Reservas en segundos'),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroPill(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

class _QuickSearchCard extends StatelessWidget {
  const _QuickSearchCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go(AppRoutes.searchTrips),
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [_cardShadow()],
          ),
          child: const Row(
            children: [
              _SearchBadge(),
              SizedBox(width: 16),
              Expanded(child: _SearchText()),
              Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }

  BoxShadow _cardShadow() {
    return BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.1),
      blurRadius: 24,
      offset: const Offset(0, 10),
    );
  }
}

class _SearchBadge extends StatelessWidget {
  const _SearchBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
    );
  }
}

class _SearchText extends StatelessWidget {
  const _SearchText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.searchTrips,
          style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Descubre opciones premium y seguras para tu próximo trayecto.',
          style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _RecentBookingsSection extends StatelessWidget {
  const _RecentBookingsSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [_panelShadow()],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(),
          const SizedBox(height: 16),
          Consumer<BookingsListViewModel>(builder: _buildContent),
        ],
      ),
    );
  }

  BoxShadow _panelShadow() {
    return BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.08),
      blurRadius: 26,
      offset: const Offset(0, 12),
    );
  }

  static Widget _buildContent(
    BuildContext context,
    BookingsListViewModel vm,
    Widget? _,
  ) {
    if (vm.isLoading) return const _LoadingBookings();
    if (vm.status == BookingsListStatus.error) return _BookingsError(vm.errorMessage);
    if (vm.bookings.isEmpty) return const _EmptyBookings();
    return _BookingsList(vm.bookings);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.homeRecentBookings,
          style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Haz seguimiento de tus reservas más recientes.',
          style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _LoadingBookings extends StatelessWidget {
  const _LoadingBookings();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 120,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }
}

class _BookingsError extends StatelessWidget {
  final String? message;

  const _BookingsError(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.accentCoralLight,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(message ?? AppStrings.errorOccurred),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final List<BookingEntity> bookings;

  const _BookingsList(this.bookings);

  @override
  Widget build(BuildContext context) {
    final recent = bookings.take(3).toList();
    return Column(
      children: recent
          .map(
            (booking) => BookingCard(
              booking: booking,
              onTap: () => context.push(
                AppRoutes.bookingDetail.replaceFirst(':id', booking.id),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.backgroundWhite,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.directions_car_outlined,
              size: 30,
              color: AppColors.textDisabled,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.noBookings,
            style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
