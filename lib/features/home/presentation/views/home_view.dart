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

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final AnimationController _introCtrl;
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _introCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    await context.read<BookingsListViewModel>().loadBookings();
    if (mounted) _introCtrl.forward();
  }

  @override
  void dispose() {
    _introCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const _BackgroundPattern(),
          SafeArea(
            child: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _refresh,
              child: _HomeScroll(_introCtrl, _pulseCtrl),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refresh() {
    return context.read<BookingsListViewModel>().loadBookings();
  }
}

class _HomeScroll extends StatelessWidget {
  final Animation<double> intro;
  final Animation<double> pulse;

  const _HomeScroll(this.intro, this.pulse);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        const _GreetingAppBar(),
        _sliverBox(_AnimatedSection(intro, 0, const _GreetingSection())),
        _sliverBox(_AnimatedSection(intro, 1, _SearchTripsCard(pulse))),
        _sliverBox(_AnimatedSection(intro, 2, const _QuickActionsSection())),
        _sliverBox(_AnimatedSection(intro, 3, const _TrustSignalsSection())),
        _sliverBox(_AnimatedSection(intro, 4, const _RecentBookingsSection())),
        _sliverBox(const SizedBox(height: 32)),
      ],
    );
  }

  SliverToBoxAdapter _sliverBox(Widget child) {
    return SliverToBoxAdapter(child: child);
  }
}

class _GreetingAppBar extends StatelessWidget {
  const _GreetingAppBar();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    return SliverAppBar(
      pinned: true,
      floating: false,
      elevation: 0,
      backgroundColor: AppColors.background,
      surfaceTintColor: Colors.transparent,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/logo.png', height: 42, width: 42),
          const SizedBox(width: 8),
          Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: AppAvatar(
            imageUrl: user?.profilePhotoUrl,
            name: user?.displayName ?? 'U',
            size: AppAvatarSize.small,
          ),
        ),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().currentUser;
    final name = user?.displayName ?? 'Usuario';
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_greeting(name), style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Text(
            AppStrings.homeSearchPrompt,
            style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }

  String _greeting(String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días, $name 👋';
    if (hour < 18) return 'Buenas tardes, $name 👋';
    return 'Buenas noches, $name 👋';
  }
}

class _AnimatedSection extends StatelessWidget {
  final Animation<double> controller;
  final int index;
  final Widget child;

  const _AnimatedSection(this.controller, this.index, this.child);

  @override
  Widget build(BuildContext context) {
    final curve = CurvedAnimation(parent: controller, curve: _curve);
    final offset = Tween(begin: const Offset(0, 0.08), end: Offset.zero);
    return FadeTransition(
      opacity: curve,
      child: SlideTransition(position: offset.animate(curve), child: child),
    );
  }

  Curve get _curve {
    final start = index * 0.14;
    return Interval(start, (start + 0.34).clamp(0.0, 1.0), curve: Curves.easeOutCubic);
  }
}

class _SearchTripsCard extends StatelessWidget {
  final Animation<double> pulse;

  const _SearchTripsCard(this.pulse);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(AppRoutes.searchTrips),
          borderRadius: BorderRadius.circular(28),
          child: Ink(decoration: _cardDecoration(), child: _SearchCardContent(pulse)),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
      boxShadow: [_cardShadow()],
    );
  }

  BoxShadow _cardShadow() {
    return BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.12),
      blurRadius: 32,
      offset: const Offset(0, 14),
    );
  }
}

class _SearchCardContent extends StatelessWidget {
  final Animation<double> pulse;

  const _SearchCardContent(this.pulse);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [_SearchCopy(theme), _AnimatedSearchIcon(pulse)]),
          const SizedBox(height: 18),
          const Wrap(spacing: 10, runSpacing: 10, children: [
            _InfoChip(Icons.shield_rounded, 'Verificados'),
            _InfoChip(Icons.bolt_rounded, 'Reserva rápida'),
            _InfoChip(Icons.auto_awesome_rounded, 'Experiencia premium'),
          ]),
        ],
      ),
    );
  }
}

class _SearchCopy extends StatelessWidget {
  final TextTheme theme;

  const _SearchCopy(this.theme);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Buscar tu próximo viaje', style: _titleStyle()),
          const SizedBox(height: 8),
          Text(
            'Explora rutas cómodas, seguras y con una experiencia pensada para ti.',
            style: _bodyStyle(),
          ),
        ],
      ),
    );
  }

  TextStyle? _titleStyle() {
    return theme.headlineSmall?.copyWith(fontWeight: FontWeight.w800);
  }

  TextStyle? _bodyStyle() {
    return theme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.4);
  }
}

class _AnimatedSearchIcon extends StatelessWidget {
  final Animation<double> pulse;

  const _AnimatedSearchIcon(this.pulse);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      child: _iconShell(),
      builder: (_, child) {
        final lift = -6 * pulse.value;
        final angle = 0.12 * pulse.value;
        return Transform.translate(
          offset: Offset(0, lift),
          child: Transform.rotate(angle: angle, child: child),
        );
      },
    );
  }

  Widget _iconShell() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 28),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.secondaryDark),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  const _QuickActionsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionIntro('Accesos rápidos', 'Todo lo importante en un vistazo.'),
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _ActionTile(Icons.history_rounded, 'Historial', AppRoutes.tripHistory)),
              SizedBox(width: 12),
              Expanded(child: _ActionTile(Icons.sos_rounded, 'SOS', AppRoutes.sos)),
              SizedBox(width: 12),
              Expanded(child: _ActionTile(Icons.support_agent_rounded, 'Soporte', AppRoutes.supportTickets)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _ActionTile(this.icon, this.label, this.route);

  @override
  Widget build(BuildContext context) {
    final tone = _tone();
    return Material(
      color: tone.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(22),
        child: Padding(padding: const EdgeInsets.all(16), child: _TileContent(icon, label, tone)),
      ),
    );
  }

  Color _tone() {
    if (route == AppRoutes.sos) return AppColors.accentCoral;
    if (route == AppRoutes.supportTickets) return AppColors.secondary;
    return AppColors.primary;
  }
}

class _TileContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color tone;

  const _TileContent(this.icon, this.label, this.tone);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: tone, size: 24),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(color: tone, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class _TrustSignalsSection extends StatelessWidget {
  const _TrustSignalsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: DecoratedBox(
        decoration: _panelDecoration(),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionIntro('Tu experiencia premium', 'Diseñado para viajes más tranquilos y eficientes.'),
              SizedBox(height: 16),
              _SignalRow(Icons.route_rounded, 'Rutas claras', 'Encuentra opciones alineadas a tu trayecto ideal.'),
              SizedBox(height: 12),
              _SignalRow(Icons.workspace_premium_rounded, 'Calidad superior', 'Prioriza comodidad, seguridad y puntualidad.'),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(28),
      border: Border.all(color: Colors.white.withValues(alpha: 0.55)),
    );
  }
}

class _SignalRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;

  const _SignalRow(this.icon, this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SignalIcon(icon),
        const SizedBox(width: 14),
        Expanded(child: _SignalCopy(title, body)),
      ],
    );
  }
}

class _SignalIcon extends StatelessWidget {
  final IconData icon;

  const _SignalIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColors.primaryDark),
    );
  }
}

class _SignalCopy extends StatelessWidget {
  final String title;
  final String body;

  const _SignalCopy(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(body, style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _SectionIntro extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionIntro(this.title, this.subtitle);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        Text(subtitle, style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class _RecentBookingsSection extends StatelessWidget {
  const _RecentBookingsSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: DecoratedBox(
        decoration: _panelDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _RecentHeader(),
              const SizedBox(height: 16),
              Consumer<BookingsListViewModel>(builder: _buildContent),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _panelDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [_panelShadow()],
    );
  }

  BoxShadow _panelShadow() {
    return BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.1),
      blurRadius: 28,
      offset: const Offset(0, 14),
    );
  }

  static Widget _buildContent(
    BuildContext context,
    BookingsListViewModel vm,
    Widget? _,
  ) {
    if (vm.isLoading) return const _LoadingState();
    if (vm.status == BookingsListStatus.error) return _BookingsError(vm.errorMessage);
    if (vm.bookings.isEmpty) return const _EmptyBookings();
    return _BookingsList(vm.bookings);
  }
}

class _RecentHeader extends StatelessWidget {
  const _RecentHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: _SectionIntro(
            AppStrings.homeRecentBookings,
            'Mantén el control de tus trayectos más recientes.',
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.myBookings),
          child: const Text('Ver todo'),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(2, (_) => const _BookingSkeleton()),
    );
  }
}

class _BookingSkeleton extends StatelessWidget {
  const _BookingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 108,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(22),
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
        color: AppColors.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(child: Text(message ?? AppStrings.errorOccurred)),
        ],
      ),
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
      children: recent.map((booking) => _bookingItem(context, booking)).toList(),
    );
  }

  Widget _bookingItem(BuildContext context, BookingEntity booking) {
    return BookingCard(
      booking: booking,
      onTap: () => context.push(
        AppRoutes.bookingDetail.replaceFirst(':id', booking.id),
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const _EmptyIcon(),
          const SizedBox(height: 14),
          Text(AppStrings.noBookings, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: () => context.go(AppRoutes.searchTrips),
            child: const Text(AppStrings.searchTrips),
          ),
        ],
      ),
    );
  }
}

class _EmptyIcon extends StatelessWidget {
  const _EmptyIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: AppColors.backgroundWhite,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.directions_car_outlined,
        color: AppColors.textDisabled,
        size: 30,
      ),
    );
  }
}

class _BackgroundPattern extends StatelessWidget {
  const _BackgroundPattern();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Align(alignment: const Alignment(-1.1, -0.9), child: _orb(AppColors.primaryLight, 180)),
          Align(alignment: const Alignment(1.2, -0.25), child: _orb(AppColors.secondaryLight, 220)),
          Align(alignment: const Alignment(0.95, 0.85), child: _orb(AppColors.accentAmberLight, 150)),
        ],
      ),
    );
  }

  Widget _orb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.26),
        shape: BoxShape.circle,
      ),
    );
  }
}
