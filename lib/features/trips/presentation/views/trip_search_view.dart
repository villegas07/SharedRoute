import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/trip_entity.dart';
import '../../domain/entities/trip_search_params.dart';
import '../viewmodels/trip_search_viewmodel.dart';
import '../widgets/trip_card.dart';

class TripSearchView extends StatelessWidget {
  const TripSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: const [
            _SearchHeader(),
            Expanded(child: _TripResults()),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends StatefulWidget {
  const _SearchHeader();

  @override
  State<_SearchHeader> createState() => _SearchHeaderState();
}

class _SearchHeaderState extends State<_SearchHeader> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _search() {
    final params = TripSearchParams(
      originCity: _textOrNull(_originController),
      destinationCity: _textOrNull(_destinationController),
    );
    context.read<TripSearchViewModel>().search(params);
  }

  String? _textOrNull(TextEditingController controller) {
    final value = controller.text.trim();
    return value.isEmpty ? null : value;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderCopy(),
          const SizedBox(height: 20),
          _RouteSearchCard(
            originController: _originController,
            destinationController: _destinationController,
            onSearch: _search,
          ),
        ],
      ),
    );
  }
}

class _HeaderCopy extends StatelessWidget {
  const _HeaderCopy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: _pillDecoration(),
          child: const Text('Viajes cómodos y seguros'),
        ),
        const SizedBox(height: 14),
        Text('Planea tu próxima ruta', style: theme.headlineMedium),
        const SizedBox(height: 8),
        Text(
          'Busca en segundos y encuentra trayectos compartidos con estilo.',
          style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  BoxDecoration _pillDecoration() {
    return BoxDecoration(
      color: AppColors.primaryLight,
      borderRadius: BorderRadius.circular(999),
    );
  }
}

class _RouteSearchCard extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;
  final VoidCallback onSearch;

  const _RouteSearchCard({
    required this.originController,
    required this.destinationController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _shellDecoration(),
      child: Column(
        children: [
          _RouteSelector(
            originController: originController,
            destinationController: destinationController,
          ),
          const SizedBox(height: 18),
          _SearchButton(onTap: onSearch),
        ],
      ),
    );
  }

  BoxDecoration _shellDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundWhite,
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x140E3140),
          blurRadius: 24,
          offset: Offset(0, 16),
        ),
      ],
    );
  }
}

class _RouteSelector extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destinationController;

  const _RouteSelector({
    required this.originController,
    required this.destinationController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: _selectorDecoration(),
          child: Column(
            children: [
              _RouteField(
                controller: originController,
                data: _RouteFieldData.origin(),
              ),
              const _RouteDivider(),
              _RouteField(
                controller: destinationController,
                data: _RouteFieldData.destination(),
              ),
            ],
          ),
        ),
        const Positioned(right: 18, top: 60, child: _SwapBadge()),
      ],
    );
  }

  BoxDecoration _selectorDecoration() {
    return BoxDecoration(
      color: AppColors.backgroundAlt,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.secondaryLight),
    );
  }
}

class _SwapBadge extends StatelessWidget {
  const _SwapBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 10)],
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.swap_vert_rounded, color: AppColors.primary),
      ),
    );
  }
}

class _RouteDivider extends StatelessWidget {
  const _RouteDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: AppColors.secondaryLight),
    );
  }
}

class _RouteFieldData {
  final String label;
  final String hint;
  final IconData icon;
  final Color color;

  const _RouteFieldData._(this.label, this.hint, this.icon, this.color);

  factory _RouteFieldData.origin() {
    return const _RouteFieldData._(
      'Salida',
      AppStrings.originCity,
      Icons.radio_button_checked_rounded,
      AppColors.primary,
    );
  }

  factory _RouteFieldData.destination() {
    return const _RouteFieldData._(
      'Destino',
      AppStrings.destinationCity,
      Icons.location_on_rounded,
      AppColors.accentCoral,
    );
  }
}

class _RouteField extends StatelessWidget {
  final TextEditingController controller;
  final _RouteFieldData data;

  const _RouteField({required this.controller, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 72, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.label, style: _labelStyle(context)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.search,
            decoration: _inputDecoration(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: data.hint,
      prefixIcon: Icon(data.icon, color: data.color, size: 18),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
    );
  }

  TextStyle? _labelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium?.copyWith(
      color: AppColors.textSecondary,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.4,
    );
  }
}

class _SearchButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: _buttonDecoration(),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.search_rounded),
          label: const Text(AppStrings.search),
          style: _buttonStyle(),
        ),
      ),
    );
  }

  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [BoxShadow(color: Color(0x337C4DC4), blurRadius: 18)],
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}

class _TripResults extends StatelessWidget {
  const _TripResults();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TripSearchViewModel>();
    return switch (vm.status) {
      TripSearchStatus.initial => const _InitialState(),
      TripSearchStatus.loading => const AppInlineLoading(),
      TripSearchStatus.empty => const AppErrorState(
        message: AppStrings.noTripsFound,
        icon: Icons.route_rounded,
      ),
      TripSearchStatus.error => AppErrorState(
        message: vm.errorMessage ?? AppStrings.errorOccurred,
      ),
      TripSearchStatus.loaded => _TripList(trips: vm.trips),
    };
  }
}

class _TripList extends StatelessWidget {
  final List<TripEntity> trips;

  const _TripList({required this.trips});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      itemCount: trips.length,
      itemBuilder: (context, index) => TripCard(
        trip: trips[index],
        onTap: () => context.push(
          AppRoutes.tripDetail.replaceFirst(':id', trips[index].id),
        ),
      ),
    );
  }
}

class _InitialState extends StatelessWidget {
  const _InitialState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _TravelBadge(),
          const SizedBox(height: 18),
          Text('Encuentra tu próximo viaje', style: theme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Elige origen y destino para descubrir rutas compartidas.',
            textAlign: TextAlign.center,
            style: theme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _TravelBadge extends StatelessWidget {
  const _TravelBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: const Icon(
        Icons.explore_rounded,
        size: 42,
        color: AppColors.secondary,
      ),
    );
  }
}
