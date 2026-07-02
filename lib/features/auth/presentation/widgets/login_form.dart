import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodels/auth_viewmodel.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnim = CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _submit(AuthViewModel vm) {
    if (!_formKey.currentState!.validate()) {
      _triggerShake();
      return;
    }
    vm.login(_emailCtrl.text.trim(), _passwordCtrl.text);
  }

  void _triggerShake() {
    HapticFeedback.mediumImpact();
    _shakeCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthViewModel>();
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(_shakeOffset(), 0),
          child: child,
        );
      },
      child: _FormContent(formKey: _formKey, child: _fields(vm)),
    );
  }

  Widget _fields(AuthViewModel vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _EmailField(controller: _emailCtrl, focusNode: _emailFocus),
        const SizedBox(height: 16),
        _PasswordField(
          controller: _passwordCtrl,
          focusNode: _passwordFocus,
          onSubmit: () => _submit(vm),
        ),
        _ErrorSection(message: vm.errorMessage),
        const SizedBox(height: 28),
        _GradientSubmitButton(
          isLoading: vm.isLoading,
          onPressed: () => _submit(vm),
        ),
      ],
    );
  }

  double _shakeOffset() {
    final wave = math.sin(_shakeCtrl.value * math.pi * 8);
    return wave * 12 * _shakeAnim.value;
  }
}

class _FormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Widget child;

  const _FormContent({required this.formKey, required this.child});

  @override
  Widget build(BuildContext context) {
    return Form(key: formKey, child: child);
  }
}

class _AnimatedFieldShell extends StatelessWidget {
  final FocusNode focusNode;
  final Widget child;

  const _AnimatedFieldShell({required this.focusNode, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: focusNode,
      child: child,
      builder: (context, innerChild) {
        return AnimatedScale(
          duration: const Duration(milliseconds: 180),
          scale: focusNode.hasFocus ? 1.015 : 1,
          curve: Curves.easeOutCubic,
          child: innerChild,
        );
      },
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const _EmailField({required this.controller, required this.focusNode});

  @override
  Widget build(BuildContext context) {
    return _AnimatedFieldShell(
      focusNode: focusNode,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: _decoration(),
        validator: _validate,
      ),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      labelText: AppStrings.email,
      hintText: 'correo@ejemplo.com',
      prefixIcon: const _PrefixIcon(
        icon: Icons.email_outlined,
        color: AppColors.secondary,
      ),
    );
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (!value.contains('@')) return 'Correo inválido';
    return null;
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  const _PasswordField({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return _AnimatedFieldShell(
      focusNode: widget.focusNode,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: _obscure,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => widget.onSubmit(),
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        decoration: _decoration(),
        validator: _validate,
      ),
    );
  }

  InputDecoration _decoration() {
    return InputDecoration(
      labelText: AppStrings.password,
      prefixIcon: const _PrefixIcon(
        icon: Icons.lock_outlined,
        color: AppColors.primary,
      ),
      suffixIcon: IconButton(
        onPressed: _toggle,
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }

  void _toggle() {
    setState(() => _obscure = !_obscure);
  }

  String? _validate(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }
}

class _PrefixIcon extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _PrefixIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  final String? message;

  const _ErrorSection({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: _transition,
        child: message == null
            ? const SizedBox.shrink()
            : _ErrorBanner(message: message!),
      ),
    );
  }

  Widget _transition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(sizeFactor: animation, child: child),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;

  const _ErrorBanner({required this.message})
    : super(key: const ValueKey('error'));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 18),
          const SizedBox(width: 10),
          Expanded(child: _ErrorText(message: message)),
        ],
      ),
    );
  }
}

class _ErrorText extends StatelessWidget {
  final String message;

  const _ErrorText({required this.message});

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: const TextStyle(
        color: AppColors.error,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _GradientSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _GradientSubmitButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      height: 56,
      decoration: _decoration(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: _content(),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: isLoading
            ? [AppColors.primaryLight, AppColors.secondaryLight]
            : [AppColors.primary, AppColors.secondary],
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: isLoading ? [] : [_shadow()],
    );
  }

  Widget _content() {
    if (isLoading) return const _LoadingIndicator();
    return const Text(
      AppStrings.loginButton,
      key: ValueKey('label'),
      style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  BoxShadow _shadow() {
    return BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      blurRadius: 16,
      offset: const Offset(0, 6),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      key: ValueKey('loading'),
      height: 22,
      width: 22,
      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
    );
  }
}
