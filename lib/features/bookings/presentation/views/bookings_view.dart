import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
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
    context.read<BookingsListViewModel>().loadBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.myBookings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<BookingsListViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          BookingsListStatus.loading || BookingsListStatus.initial =>
            const AppInlineLoading(),
          BookingsListStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: vm.loadBookings,
            ),
          BookingsListStatus.empty => const AppErrorState(
              message: AppStrings.noBookings,
              icon: Icons.book_outlined,
            ),
          BookingsListStatus.loaded => _BookingsList(vm: vm),
        },
      ),
    );
  }
}

class _BookingsList extends StatelessWidget {
  final BookingsListViewModel vm;

  const _BookingsList({required this.vm});

  @override
  Widget build(BuildContext context) => ListView.builder(
        itemCount: vm.bookings.length,
        itemBuilder: (context, index) => BookingCard(
          booking: vm.bookings[index],
          onTap: () => context.push(
            AppRoutes.bookingDetail
                .replaceFirst(':id', vm.bookings[index].id),
          ),
        ),
      );
}
