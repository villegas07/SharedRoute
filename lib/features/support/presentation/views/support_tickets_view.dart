import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../viewmodels/tickets_list_viewmodel.dart';
import '../widgets/ticket_card.dart';

class SupportTicketsView extends StatefulWidget {
  const SupportTicketsView({super.key});

  @override
  State<SupportTicketsView> createState() => _SupportTicketsViewState();
}

class _SupportTicketsViewState extends State<SupportTicketsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<TicketsListViewModel>().loadTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.support)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final vm = context.read<TicketsListViewModel>();
          await context.push(AppRoutes.createSupportTicket);
          vm.loadTickets();
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<TicketsListViewModel>(
        builder: (context, vm, _) => switch (vm.status) {
          TicketsListStatus.initial ||
          TicketsListStatus.loading =>
            const AppInlineLoading(),
          TicketsListStatus.error => AppErrorState(
              message: vm.errorMessage ?? AppStrings.errorOccurred,
              onRetry: vm.loadTickets,
            ),
          TicketsListStatus.empty => const Center(
              child: Text(AppStrings.noTickets),
            ),
          TicketsListStatus.loaded => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vm.tickets.length,
              itemBuilder: (context, index) {
                final ticket = vm.tickets[index];
                return TicketCard(
                  ticket: ticket,
                  onTap: () => context.push(
                    AppRoutes.supportTicketDetail.replaceFirst(':id', ticket.id),
                  ),
                );
              },
            ),
        },
      ),
    );
  }
}
