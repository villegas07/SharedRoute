import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/register_params.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(RegisterViewModel vm) {
    if (!_formKey.currentState!.validate()) return;
    vm.register(RegisterParams(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: _NameField(
                  controller: _firstNameController,
                  label: AppStrings.firstName,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _NameField(
                  controller: _lastNameController,
                  label: AppStrings.lastName,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _EmailField(controller: _emailController),
          const SizedBox(height: 16),
          _PhoneField(controller: _phoneController),
          const SizedBox(height: 16),
          _PasswordField(controller: _passwordController),
          const SizedBox(height: 16),
          _ConfirmPasswordField(
            controller: _confirmPasswordController,
            passwordController: _passwordController,
          ),
          if (vm.errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              vm.errorMessage!,
              style: const TextStyle(color: AppColors.error, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          _SubmitButton(isLoading: vm.isLoading, onPressed: () => _submit(vm)),
        ],
      ),
    );
  }
}

class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const _NameField({required this.controller, required this.label});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(labelText: label),
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
      );
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: const InputDecoration(
          labelText: AppStrings.email,
          prefixIcon: Icon(Icons.email_outlined),
        ),
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
      );
}

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneField({required this.controller});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(
          labelText: AppStrings.phone,
          prefixIcon: Icon(Icons.phone_outlined),
        ),
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
      );
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: AppStrings.password,
          prefixIcon: Icon(Icons.lock_outlined),
        ),
        validator: (v) =>
            (v == null || v.isEmpty) ? AppStrings.fieldRequired : null,
      );
}

class _ConfirmPasswordField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;

  const _ConfirmPasswordField({
    required this.controller,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: AppStrings.confirmPassword,
          prefixIcon: Icon(Icons.lock_outlined),
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return AppStrings.fieldRequired;
          if (v != passwordController.text) return AppStrings.passwordMismatch;
          return null;
        },
      );
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: AppColors.backgroundWhite,
                  strokeWidth: 2,
                ),
              )
            : const Text(AppStrings.registerButton),
      );
}
