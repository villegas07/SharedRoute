import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading.dart';
import '../viewmodels/sos_viewmodel.dart';
import '../widgets/emergency_contact_card.dart';

class SosView extends StatefulWidget {
  const SosView({super.key});

  @override
  State<SosView> createState() => _SosViewState();
}

class _SosViewState extends State<SosView> {
  @override
  void initState() {
    super.initState();
    context.read<SosViewModel>().loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.sos)),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final vm = context.read<SosViewModel>();
          await context.push(AppRoutes.addEmergencyContact);
          vm.loadContacts();
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<SosViewModel>(
        builder: (context, vm, _) {
          _handleAlertStatus(context, vm);
          return Column(
            children: [
              _SosAlertButton(vm: vm),
              Expanded(child: _buildContactsList(context, vm)),
            ],
          );
        },
      ),
    );
  }

  void _handleAlertStatus(BuildContext context, SosViewModel vm) {
    if (vm.alertStatus == AlertStatus.sent) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.alertSent)),
        );
        vm.resetAlertStatus();
      });
    }
  }

  Widget _buildContactsList(BuildContext context, SosViewModel vm) {
    return switch (vm.status) {
      SosStatus.initial || SosStatus.loading => const AppInlineLoading(),
      SosStatus.error => AppErrorState(
          message: vm.errorMessage ?? AppStrings.errorOccurred,
          onRetry: vm.loadContacts,
        ),
      SosStatus.empty => const Center(
          child: Text(AppStrings.noEmergencyContacts),
        ),
      SosStatus.loaded => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vm.contacts.length,
          itemBuilder: (context, index) {
            final contact = vm.contacts[index];
            return EmergencyContactCard(
              contact: contact,
              onDelete: () => vm.deleteContact(contact.id),
            );
          },
        ),
    };
  }
}

class _SosAlertButton extends StatelessWidget {
  final SosViewModel vm;

  const _SosAlertButton({required this.vm});

  @override
  Widget build(BuildContext context) {
    final isSending = vm.alertStatus == AlertStatus.sending;
    return Container(
      padding: const EdgeInsets.all(24),
      child: ElevatedButton(
        onPressed: isSending ? null : vm.triggerAlert,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.error,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: isSending
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.triggerAlert,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
