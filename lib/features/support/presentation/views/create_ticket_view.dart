import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/create_ticket_params.dart';
import '../../domain/entities/support_ticket_entity.dart';
import '../viewmodels/create_ticket_viewmodel.dart';

class CreateTicketView extends StatefulWidget {
  const CreateTicketView({super.key});

  @override
  State<CreateTicketView> createState() => _CreateTicketViewState();
}

class _CreateTicketViewState extends State<CreateTicketView> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  TicketCategory _selectedCategory = TicketCategory.other;

  @override
  void dispose() {
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.newTicket),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<CreateTicketViewModel>(
        builder: (context, vm, _) {
          if (vm.status == CreateTicketStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text(AppStrings.ticketSent)),
              );
              context.pop();
            });
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<TicketCategory>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: AppStrings.ticketCategory,
                      border: OutlineInputBorder(),
                    ),
                    items: TicketCategory.values
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(_categoryLabel(c)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedCategory = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.ticketSubject,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v?.isEmpty == true ? AppStrings.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.ticketDescription,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    validator: (v) =>
                        v?.isEmpty == true ? AppStrings.fieldRequired : null,
                  ),
                  if (vm.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      vm.errorMessage!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.red),
                    ),
                  ],
                  const Spacer(),
                  AppButton(
                    label: AppStrings.newTicket,
                    isLoading: vm.isLoading,
                    onPressed: () => _submit(vm),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(CreateTicketViewModel vm) {
    if (!_formKey.currentState!.validate()) return;
    vm.submit(CreateTicketParams(
      subject: _subjectController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
    ));
  }

  String _categoryLabel(TicketCategory c) => switch (c) {
        TicketCategory.payment => 'Pago',
        TicketCategory.trip => 'Viaje',
        TicketCategory.account => 'Cuenta',
        TicketCategory.other => 'Otro',
      };
}
