import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(AuthViewModel viewModel) {
    if (!_formKey.currentState!.validate()) return;
    viewModel.login(_emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailField(controller: _emailController),
          const SizedBox(height: 16),
          _PasswordField(controller: _passwordController),
          const SizedBox(height: 8),
          if (viewModel.errorMessage != null)
            _ErrorMessage(viewModel.errorMessage!),
          const SizedBox(height: 24),
          _SubmitButton(
            isLoading: viewModel.isLoading,
            onPressed: () => _submit(viewModel),
          ),
        ],
      ),
    );
  }
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

class _ErrorMessage extends StatelessWidget {
  final String message;

  const _ErrorMessage(this.message);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          message,
          style: const TextStyle(color: AppColors.error, fontSize: 13),
          textAlign: TextAlign.center,
        ),
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
            : const Text(AppStrings.loginButton),
      );
}
