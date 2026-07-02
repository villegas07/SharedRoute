import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../viewmodels/ticket_detail_viewmodel.dart';

class SupportTicketDetailView extends StatefulWidget {
  final String ticketId;

  const SupportTicketDetailView({super.key, required this.ticketId});

  @override
  State<SupportTicketDetailView> createState() =>
      _SupportTicketDetailViewState();
}

class _SupportTicketDetailViewState extends State<SupportTicketDetailView> {
  @override
  void initState() {
    super.initState();
    context.read<TicketDetailViewModel>().loadTicket(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.support),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<TicketDetailViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          TicketDetailStatus.initial ||
          TicketDetailStatus.loading =>
            const AppInlineLoading(),
          TicketDetailStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: () => vm.loadTicket(widget.ticketId),
            ),
          TicketDetailStatus.loaded => _TicketContent(ticket: vm.ticket!),
        },
      ),
    );
  }
}

class _TicketContent extends StatelessWidget {
  final SupportTicketEntity ticket;

  const _TicketContent({required this.ticket});

  String _formatDate(String iso) {
    try {
      return DateFormat('d MMM yyyy - HH:mm', 'es_CO')
          .format(DateTime.parse(iso).toLocal());
    } catch (_) {
      return iso;
    }
  }

  String _categoryLabel(TicketCategory c) => switch (c) {
        TicketCategory.payment => 'Pago',
        TicketCategory.trip => 'Viaje',
        TicketCategory.account => 'Cuenta',
        TicketCategory.other => 'Otro',
      };

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _headerCard(context),
          const SizedBox(height: 16),
          _descriptionCard(context),
          if (ticket.response != null) ...[
            const SizedBox(height: 16),
            _responseCard(context),
          ],
        ],
      ),
    );
  }

  Widget _headerCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ticket.subject,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                AppStatusChip(status: _mapStatus(ticket.status)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_categoryLabel(ticket.category)),
                ),
                const Spacer(),
                Text(
                  _formatDate(ticket.createdAt),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.ticketDescription,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(ticket.description),
          ],
        ),
      ),
    );
  }

  Widget _responseCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.backgroundAlt,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.support_agent, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  AppStrings.ticketResponse,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(ticket.response!),
          ],
        ),
      ),
    );
  }

  AppChipStatus _mapStatus(TicketStatus s) => switch (s) {
        TicketStatus.open => AppChipStatus.published,
        TicketStatus.inProgress => AppChipStatus.inProgress,
        TicketStatus.resolved => AppChipStatus.completed,
        TicketStatus.closed => AppChipStatus.cancelled,
      };
}
