import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/booking_entity.dart';
import '../viewmodels/bookings_list_viewmodel.dart';

class BookingDetailView extends StatefulWidget {
  final String bookingId;

  const BookingDetailView({super.key, required this.bookingId});

  @override
  State<BookingDetailView> createState() => _BookingDetailViewState();
}

class _BookingDetailViewState extends State<BookingDetailView> {
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
      appBar: AppBar(
        title: const Text('Detalle de reserva'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<BookingsListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return const AppInlineLoading();

          final booking = vm.bookings
              .where((b) => b.id == widget.bookingId)
              .firstOrNull;

          if (booking == null) {
            return const AppErrorState(message: 'Reserva no encontrada');
          }
          return _BookingDetailContent(
            booking: booking,
            onCancel: () => _confirmCancel(context, vm, booking),
          );
        },
      ),
    );
  }

  void _confirmCancel(
    BuildContext context,
    BookingsListViewModel vm,
    BookingEntity booking,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.cancelBooking),
        content: const Text('¿Seguro que deseas cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              vm.cancelBooking(booking.id);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}

class _BookingDetailContent extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onCancel;

  const _BookingDetailContent({
    required this.booking,
    required this.onCancel,
  });

  AppChipStatus _mapStatus(BookingStatus s) => switch (s) {
        BookingStatus.pending => AppChipStatus.pending,
        BookingStatus.confirmed => AppChipStatus.confirmed,
        BookingStatus.cancelledByPassenger =>
          AppChipStatus.cancelledByPassenger,
        BookingStatus.cancelledByDriver => AppChipStatus.cancelledByDriver,
        BookingStatus.completed => AppChipStatus.completed,
      };

  bool get _canCancel =>
      booking.status == BookingStatus.pending ||
      booking.status == BookingStatus.confirmed;

  @override
  Widget build(BuildContext context) {
    final price = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '\$',
      decimalDigits: 0,
    ).format(booking.totalPrice);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado'),
                      AppStatusChip(status: _mapStatus(booking.status)),
                    ],
                  ),
                  const Divider(),
                  _InfoRow(
                    label: AppStrings.seatsReserved,
                    value: booking.seatsReserved.toString(),
                  ),
                  const Divider(),
                  _InfoRow(
                    label: AppStrings.totalPrice,
                    value: price,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (_canCancel)
            OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
              ),
              child: const Text(AppStrings.cancelBooking),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
}
