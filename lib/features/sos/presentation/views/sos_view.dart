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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadContacts());
  }

  void _loadContacts() {
    if (!mounted) return;
    context.read<SosViewModel>().loadContacts();
  }

  Future<void> _openAddContact() async {
    await context.push(AppRoutes.addEmergencyContact);
    if (mounted) context.read<SosViewModel>().loadContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.sos)),
      floatingActionButton: _AddContactFab(onTap: _openAddContact),
      body: Consumer<SosViewModel>(
        builder: (context, vm, _) {
          _handleStatus(context, vm);
          return _SosContent(vm: vm);
        },
      ),
    );
  }

  void _handleStatus(BuildContext context, SosViewModel vm) {
    if (vm.alertStatus == AlertStatus.sent) {
      _showSnack(context, AppStrings.alertSent, AppColors.success);
    }
    if (vm.alertStatus == AlertStatus.error) {
      _showSnack(context, AppStrings.errorOccurred, AppColors.error);
    }
  }

  void _showSnack(BuildContext context, String message, Color color) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(_snackBar(message, color));
      context.read<SosViewModel>().resetAlertStatus();
    });
  }

  SnackBar _snackBar(String message, Color color) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}

class _SosContent extends StatelessWidget {
  final SosViewModel vm;

  const _SosContent({required this.vm});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 92),
      child: Column(
        children: [
          _SosHero(vm: vm),
          const SizedBox(height: 24),
          _ContactsSection(vm: vm),
        ],
      ),
    );
  }
}

class _AddContactFab extends StatelessWidget {
  final VoidCallback onTap;

  const _AddContactFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onTap,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.person_add_alt_1_rounded),
      label: const Text(AppStrings.addContact),
    );
  }
}

class _SosHero extends StatelessWidget {
  final SosViewModel vm;

  const _SosHero({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _decoration,
      child: Column(
        children: [
          const _HeroBadge(),
          const SizedBox(height: 18),
          _HeroText(isSending: vm.alertStatus == AlertStatus.sending),
          const SizedBox(height: 24),
          _SosActionButton(vm: vm),
          const SizedBox(height: 20),
          const Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              _InfoChip(
                icon: Icons.location_on_rounded,
                label: 'Comparte tu ubicación',
              ),
              _InfoChip(
                icon: Icons.people_alt_rounded,
                label: 'Avisa a tus contactos',
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration get _decoration {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.error, AppColors.accentCoral],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          color: AppColors.error.withValues(alpha: 0.28),
          blurRadius: 30,
          offset: const Offset(0, 16),
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Asistencia inmediata',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final bool isSending;

  const _HeroText({required this.isSending});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final subtitle = isSending
        ? 'Estamos avisando a tus contactos registrados.'
        : 'Presiona el botón central si necesitas ayuda ahora mismo.';
    return Column(
      children: [
        Text(
          AppStrings.triggerAlert,
          textAlign: TextAlign.center,
          style: theme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.86),
          ),
        ),
      ],
    );
  }
}

class _SosActionButton extends StatefulWidget {
  final SosViewModel vm;

  const _SosActionButton({required this.vm});

  @override
  State<_SosActionButton> createState() => _SosActionButtonState();
}

class _SosActionButtonState extends State<_SosActionButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSending = widget.vm.alertStatus == AlertStatus.sending;
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) => _buildPulseButton(isSending),
    );
  }

  Widget _buildPulseButton(bool isSending) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _PulseRing(value: _pulseCtrl.value, delay: 0),
        _PulseRing(value: _pulseCtrl.value, delay: 0.33),
        _PulseRing(value: _pulseCtrl.value, delay: 0.66),
        _SosButton(isSending: isSending, onTap: _sendAlert),
      ],
    );
  }

  void _sendAlert() => widget.vm.sendAlert();
}

class _PulseRing extends StatelessWidget {
  final double value;
  final double delay;

  const _PulseRing({required this.value, required this.delay});

  @override
  Widget build(BuildContext context) {
    final progress = ((value + delay) % 1.0);
    final scale = 1.0 + progress * 0.5;
    final opacity = (1.0 - progress).clamp(0.0, 0.4);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: opacity),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  final bool isSending;
  final VoidCallback onTap;

  const _SosButton({required this.isSending, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 8,
      shadowColor: Colors.black26,
      child: InkWell(
        onTap: isSending ? null : onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          child: isSending ? _loadingIcon() : _sosIcon(),
        ),
      ),
    );
  }

  Widget _sosIcon() {
    return const Icon(
      Icons.sos_rounded,
      color: AppColors.error,
      size: 36,
    );
  }

  Widget _loadingIcon() {
    return const SizedBox(
      width: 28,
      height: 28,
      child: CircularProgressIndicator(
        color: AppColors.error,
        strokeWidth: 3,
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactsSection extends StatelessWidget {
  final SosViewModel vm;

  const _ContactsSection({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ContactsHeader(total: vm.contacts.length),
          const SizedBox(height: 16),
          _ContactsContent(vm: vm),
        ],
      ),
    );
  }
}

class _ContactsHeader extends StatelessWidget {
  final int total;

  const _ContactsHeader({required this.total});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.emergencyContacts,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                'Mantén al menos un contacto listo para emergencias.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        _ContactCount(total: total),
      ],
    );
  }
}

class _ContactCount extends StatelessWidget {
  final int total;

  const _ContactCount({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        '$total',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ContactsContent extends StatelessWidget {
  final SosViewModel vm;

  const _ContactsContent({required this.vm});

  @override
  Widget build(BuildContext context) {
    return switch (vm.status) {
      SosStatus.initial || SosStatus.loading => const AppInlineLoading(),
      SosStatus.error => AppErrorState(
        message: vm.errorMessage ?? AppStrings.errorOccurred,
        onRetry: vm.loadContacts,
      ),
      SosStatus.empty => const _EmptyContactsState(),
      SosStatus.loaded => _ContactList(vm: vm),
    };
  }
}

class _EmptyContactsState extends StatelessWidget {
  const _EmptyContactsState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.backgroundAlt,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.people_outline_rounded,
            size: 42,
            color: AppColors.textDisabled,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.noEmergencyContacts,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Agrega personas de confianza para enviar alertas en segundos.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ContactList extends StatelessWidget {
  final SosViewModel vm;

  const _ContactList({required this.vm});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: vm.contacts
          .map(
            (contact) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: EmergencyContactCard(
                contact: contact,
                onDelete: () => vm.deleteContact(contact.id),
              ),
            ),
          )
          .toList(),
    );
  }
}
