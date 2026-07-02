import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodels/forgot_password_viewmodel.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              _BackButton(),
              SizedBox(height: 32),
              _AccentHero(),
              SizedBox(height: 32),
              _TitleBlock(),
              SizedBox(height: 32),
              _ForgotPasswordCard(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: context.pop,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _AccentHero extends StatelessWidget {
  const _AccentHero();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: _gradient(),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock_reset_rounded,
          size: 56,
          color: AppColors.primary,
        ),
      ),
    );
  }

  LinearGradient _gradient() {
    return LinearGradient(
      colors: [
        AppColors.primaryLight.withValues(alpha: 0.9),
        AppColors.secondaryLight.withValues(alpha: 0.7),
      ],
    );
  }
}

class _TitleBlock extends StatelessWidget {
  const _TitleBlock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          AppStrings.forgotPasswordTitle,
          style: theme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.forgotPasswordSubtitle,
          style: theme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ForgotPasswordCard extends StatelessWidget {
  const _ForgotPasswordCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: const _ForgotPasswordForm(),
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  const _ForgotPasswordForm();

  @override
  State<_ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<ForgotPasswordViewModel>().sendResetEmail(
      _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ForgotPasswordViewModel>(
      builder: (context, vm, _) {
        if (vm.emailSent) return _SuccessState(onPressed: context.pop);
        return _buildForm(vm);
      },
    );
  }

  Widget _buildForm(ForgotPasswordViewModel vm) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _EmailField(controller: _emailController),
          _ErrorText(message: vm.errorMessage),
          const SizedBox(height: 24),
          _ActionButton(isLoading: vm.isLoading, onPressed: _submit),
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: _decoration(),
      validator: _validateEmail,
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      labelText: AppStrings.email,
      prefixIcon: const Icon(Icons.email_outlined),
      filled: true,
      fillColor: AppColors.backgroundAlt,
      border: _border(),
      enabledBorder: _border(),
      focusedBorder: _border(AppColors.primary),
    );
  }

  OutlineInputBorder _border([Color color = Colors.transparent]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: color, width: 1.2),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (!value.contains('@')) return 'Correo inválido';
    return null;
  }
}

class _ErrorText extends StatelessWidget {
  final String? message;

  const _ErrorText({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox(height: 0);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Text(
        message!,
        style: const TextStyle(color: AppColors.error, fontSize: 13),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _ActionButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const _LoadingIndicator()
            : const Text(AppStrings.sendResetEmail),
      ),
    );
  }
}

class _SuccessState extends StatelessWidget {
  final VoidCallback onPressed;

  const _SuccessState({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _successIcon(),
        const SizedBox(height: 20),
        _message(context),
        const SizedBox(height: 24),
        OutlinedButton(
          onPressed: onPressed,
          child: const Text('Volver al login'),
        ),
      ],
    );
  }

  Widget _successIcon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFB8F0D4),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.check_rounded,
        color: AppColors.success,
        size: 40,
      ),
    );
  }

  Widget _message(BuildContext context) {
    return Text(
      AppStrings.resetEmailSent,
      style: Theme.of(context).textTheme.bodyLarge,
      textAlign: TextAlign.center,
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
