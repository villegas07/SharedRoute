import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodels/profile_viewmodel.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileViewModel>().user;
    _firstNameController =
        TextEditingController(text: user?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: user?.lastName ?? '');
    _phoneController =
        TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save(ProfileViewModel vm) {
    if (!_formKey.currentState!.validate()) return;
    vm.updateProfile(vm.user!.id, {
      'firstName': _firstNameController.text.trim(),
      'lastName': _lastNameController.text.trim(),
      'phone': _phoneController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.status == ProfileStatus.saved) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => context.pop());
          }
          return _EditForm(
            formKey: _formKey,
            firstNameController: _firstNameController,
            lastNameController: _lastNameController,
            phoneController: _phoneController,
            isSaving: vm.isSaving,
            errorMessage: vm.errorMessage,
            onSave: () => _save(vm),
          );
        },
      ),
    );
  }
}

class _EditForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController phoneController;
  final bool isSaving;
  final String? errorMessage;
  final VoidCallback onSave;

  const _EditForm({
    required this.formKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.isSaving,
    this.errorMessage,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: firstNameController,
              decoration:
                  const InputDecoration(labelText: AppStrings.firstName),
              validator: (v) =>
                  (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameController,
              decoration:
                  const InputDecoration(labelText: AppStrings.lastName),
              validator: (v) =>
                  (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: AppStrings.phone,
                prefixIcon: Icon(Icons.phone_outlined),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: const TextStyle(color: AppColors.error, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: isSaving ? null : onSave,
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.backgroundWhite,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(AppStrings.saveChanges),
            ),
          ],
        ),
      ),
    );
  }
}
