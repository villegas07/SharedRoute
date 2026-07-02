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
  bool _obscurePassword = true;

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
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          _buildError(viewModel),
          const SizedBox(height: 28),
          _SubmitButton(
            isLoading: viewModel.isLoading,
            onPressed: () => _submit(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: _decoration(AppStrings.email, Icons.email_outlined),
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submit(context.read<AuthViewModel>()),
      decoration: _passwordDecoration(),
      validator: _validatePassword,
    );
  }

  Widget _buildError(AuthViewModel viewModel) {
    if (viewModel.errorMessage == null) return const SizedBox(height: 0);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: _ErrorBanner(viewModel.errorMessage!),
    );
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: AppColors.backgroundAlt,
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppColors.primary),
    );
  }

  InputDecoration _passwordDecoration() {
    return _decoration(AppStrings.password, Icons.lock_outlined).copyWith(
      suffixIcon: IconButton(
        icon: Icon(_passwordIcon(), color: AppColors.textSecondary),
        onPressed: _togglePassword,
      ),
    );
  }

  OutlineInputBorder _border([Color color = Colors.transparent]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  IconData _passwordIcon() {
    return _obscurePassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
  }

  void _togglePassword() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (!value.contains('@')) return 'Correo inválido';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentCoralLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [_icon(), const SizedBox(width: 8), _text()]),
    );
  }

  Widget _icon() {
    return const Icon(
      Icons.error_outline_rounded,
      color: AppColors.error,
      size: 18,
    );
  }

  Widget _text() {
    return Expanded(
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.error,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const _LoadingIndicator()
            : const Text(AppStrings.loginButton),
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 22,
      width: 22,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
    );
  }
}
