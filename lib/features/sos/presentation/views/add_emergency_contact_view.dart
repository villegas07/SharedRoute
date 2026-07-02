import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/add_contact_params.dart';
import '../viewmodels/add_contact_viewmodel.dart';

class AddEmergencyContactView extends StatefulWidget {
  const AddEmergencyContactView({super.key});

  @override
  State<AddEmergencyContactView> createState() =>
      _AddEmergencyContactViewState();
}

class _AddEmergencyContactViewState extends State<AddEmergencyContactView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationshipController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.addContact),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AddContactViewModel>(
        builder: (context, vm, _) {
          if (vm.status == AddContactStatus.success) {
            WidgetsBinding.instance.addPostFrameCallback((_) => context.pop());
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.contactName,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v?.isEmpty == true ? AppStrings.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: AppStrings.contactPhone,
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        v?.isEmpty == true ? AppStrings.fieldRequired : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _relationshipController,
                    decoration: const InputDecoration(
                      labelText: AppStrings.contactRelationship,
                      border: OutlineInputBorder(),
                    ),
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
                    label: AppStrings.addContact,
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

  void _submit(AddContactViewModel vm) {
    if (!_formKey.currentState!.validate()) return;
    vm.submit(AddContactParams(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      relationship: _relationshipController.text.trim(),
    ));
  }
}
