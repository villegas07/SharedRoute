import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../domain/entities/trip_search_params.dart';
import '../viewmodels/trip_search_viewmodel.dart';
import '../widgets/trip_card.dart';

class TripSearchView extends StatelessWidget {
  const TripSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.searchTrips),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          const _SearchForm(),
          const Divider(height: 1),
          const Expanded(child: _TripList()),
        ],
      ),
    );
  }
}

class _SearchForm extends StatefulWidget {
  const _SearchForm();

  @override
  State<_SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<_SearchForm> {
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  void _search(TripSearchViewModel vm) {
    vm.search(TripSearchParams(
      originCity: _originController.text.trim().isEmpty
          ? null
          : _originController.text.trim(),
      destinationCity: _destinationController.text.trim().isEmpty
          ? null
          : _destinationController.text.trim(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TripSearchViewModel>();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _CityField(
            controller: _originController,
            hint: AppStrings.originCity,
            icon: Icons.trip_origin,
          ),
          const SizedBox(height: 8),
          _CityField(
            controller: _destinationController,
            hint: AppStrings.destinationCity,
            icon: Icons.location_on_outlined,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _search(vm),
              icon: const Icon(Icons.search),
              label: const Text(AppStrings.search),
            ),
          ),
        ],
      ),
    );
  }
}

class _CityField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;

  const _CityField({
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.primary),
        ),
      );
}

class _TripList extends StatelessWidget {
  const _TripList();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TripSearchViewModel>();

    return switch (vm.status) {
      TripSearchStatus.initial => const _InitialState(),
      TripSearchStatus.loading => const AppInlineLoading(),
      TripSearchStatus.empty => const AppErrorState(
          message: AppStrings.noTripsFound,
          icon: Icons.directions_car_outlined,
        ),
      TripSearchStatus.error => AppErrorState(
          message: vm.errorMessage ?? AppStrings.errorOccurred,
          onRetry: null,
        ),
      TripSearchStatus.loaded => ListView.builder(
          itemCount: vm.trips.length,
          itemBuilder: (context, index) => TripCard(
            trip: vm.trips[index],
            onTap: () => context.push(
              AppRoutes.tripDetail.replaceFirst(':id', vm.trips[index].id),
            ),
          ),
        ),
    };
  }
}

class _InitialState extends StatelessWidget {
  const _InitialState();

  @override
  Widget build(BuildContext context) => const AppErrorState(
        message: 'Ingresa origen y destino para buscar viajes',
        icon: Icons.search_rounded,
      );
}
