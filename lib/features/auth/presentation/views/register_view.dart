import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../viewmodels/register_viewmodel.dart';
import '../widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(children: const [_RegisterHeader(), _FormContent()]),
      ),
    );
  }
}

class _RegisterHeader extends StatelessWidget {
  const _RegisterHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: _headerPadding(context),
      decoration: _decoration(),
      child: const _HeaderBody(),
    );
  }

  EdgeInsets _headerPadding(BuildContext context) {
    final top = MediaQuery.of(context).padding.top + 16;
    return EdgeInsets.fromLTRB(24, top, 24, 36);
  }

  BoxDecoration _decoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      ),
    );
  }
}

class _HeaderBody extends StatelessWidget {
  const _HeaderBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeaderBackButton(),
        SizedBox(height: 20),
        _HeaderTitle(),
        SizedBox(height: 8),
        _HeaderSubtitle(),
      ],
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.pop,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.headlineLarge;
    return Text(
      AppStrings.register,
      style: style?.copyWith(color: Colors.white),
    );
  }
}

class _HeaderSubtitle extends StatelessWidget {
  const _HeaderSubtitle();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Text(
      'Crea tu cuenta y empieza a compartir viajes',
      style: style?.copyWith(color: Colors.white70),
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterViewModel>(
      builder: (ctx, vm, _) {
        _handleSuccess(ctx, vm);
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            children: const [_FormCard(), SizedBox(height: 24), _FooterLink()],
          ),
        );
      },
    );
  }

  void _handleSuccess(BuildContext context, RegisterViewModel vm) {
    if (vm.status != RegisterStatus.success) return;
    WidgetsBinding.instance.addPostFrameCallback((_) => context.pop());
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: const RegisterForm(),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: context.pop,
          child: const Text(
            AppStrings.loginLink,
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
