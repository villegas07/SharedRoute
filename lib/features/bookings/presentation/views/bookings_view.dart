import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_card_shimmer.dart';
import '../viewmodels/bookings_list_viewmodel.dart';
import '../widgets/booking_card.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView> {
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
      body: Consumer<BookingsListViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          BookingsListStatus.loading ||
          BookingsListStatus.initial => const Padding(
            padding: EdgeInsets.all(20),
            child: AppCardShimmer(),
          ),
          BookingsListStatus.error => _BookingsShell(
            count: vm.bookings.length,
            child: AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: vm.loadBookings,
            ),
          ),
          BookingsListStatus.empty => _BookingsShell(
            count: 0,
            child: _EmptyBookingsState(onRefresh: vm.loadBookings),
          ),
          BookingsListStatus.loaded => _BookingsShell(
            count: vm.bookings.length,
            child: _BookingsList(vm: vm),
          ),
        },
      ),
    );
  }
}

class _BookingsShell extends StatelessWidget {
  final int count;
  final Widget child;

  const _BookingsShell({required this.count, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BookingsHeader(count: count),
        Expanded(child: child),
      ],
    );
  }
}

class _BookingsHeader extends StatelessWidget {
  final int count;

  const _BookingsHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topInset + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderTopRow(count: count),
          const SizedBox(height: 18),
          Text(
            AppStrings.myBookings,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Consulta el estado de tus reservas y mantén tus viajes bajo control.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.84),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTopRow extends StatelessWidget {
  final int count;

  const _HeaderTopRow({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _HeaderIcon(onTap: context.pop),
        const Spacer(),
        _CountBadge(count: count),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final VoidCallback onTap;

  const _HeaderIcon({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.18),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Icon(Icons.arrow_back_rounded, color: Colors.white),
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count reservas',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final BookingsListViewModel vm;

  const _BookingsList({required this.vm});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: vm.loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(4, 18, 4, 24),
        itemCount: vm.bookings.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) return _SummaryCard(count: vm.bookings.length);
          final booking = vm.bookings[index - 1];
          return BookingCard(
            booking: booking,
            onTap: () => ctx.push(
              AppRoutes.bookingDetail.replaceFirst(':id', booking.id),
            ),
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final int count;

  const _SummaryCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const _SummaryIcon(),
          const SizedBox(width: 14),
          Expanded(child: _SummaryText(count: count)),
        ],
      ),
    );
  }
}

class _SummaryIcon extends StatelessWidget {
  const _SummaryIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(
        Icons.confirmation_number_rounded,
        color: AppColors.secondary,
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  final int count;

  const _SummaryText({required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count reservas activas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Desliza hacia abajo para actualizar tus próximos movimientos.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _EmptyBookingsState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyBookingsState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: const [
          SizedBox(height: 36),
          _EmptyIllustration(),
          SizedBox(height: 24),
          _EmptyCopy(),
          SizedBox(height: 20),
          _EmptyAction(),
        ],
      ),
    );
  }
}

class _EmptyIllustration extends StatelessWidget {
  const _EmptyIllustration();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.secondaryLight],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const Icon(
        Icons.bookmark_outline_rounded,
        size: 54,
        color: AppColors.primaryDark,
      ),
    );
  }
}

class _EmptyCopy extends StatelessWidget {
  const _EmptyCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppStrings.noBookings,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Explora rutas disponibles y crea tu primera reserva en segundos.',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _EmptyAction extends StatelessWidget {
  const _EmptyAction();

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.push(AppRoutes.searchTrips),
      icon: const Icon(Icons.search_rounded),
      label: const Text('Buscar viajes'),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
