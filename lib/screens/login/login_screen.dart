import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingL,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: AppConstants.paddingL),
                  _buildTitle(),
                  const SizedBox(height: AppConstants.paddingXL),
                  _buildLoginCard(),
                  const SizedBox(height: AppConstants.paddingL),
                  _buildRegisterText(),
                  const SizedBox(height: AppConstants.paddingL),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: AppColors.primaryGradient,
      ),
      child: const Icon(
        Icons.directions_car,
        size: 50,
        color: AppColors.white,
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: const [
        Text(
          AppConstants.appName,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.italic,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 8),
        Text(
          AppConstants.appSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingXL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Iniciar Sesión',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 30),
          _buildEmailField(),
          const SizedBox(height: AppConstants.paddingL),
          _buildPasswordField(),
          const SizedBox(height: AppConstants.paddingM),
          _buildRememberForgot(),
          const SizedBox(height: AppConstants.paddingL),
          _buildLoginButton(),
          const SizedBox(height: AppConstants.paddingL),
          _buildDivider(),
          const SizedBox(height: AppConstants.paddingL),
          _buildSocialButtons(),
        ],
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Correo electrónico',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'tu.correo@universidad.edu',
            hintStyle: const TextStyle(color: AppColors.textDisabled),
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textLight,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contraseña',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: 'Tu contraseña',
            hintStyle: const TextStyle(color: AppColors.textDisabled),
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textLight,
              size: 20,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textLight,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      children: [
        SizedBox(
          height: 20,
          width: 20,
          child: Checkbox(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: const BorderSide(
              color: AppColors.textDisabled,
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Recordarme',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textDark,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            // TODO: Implementar recuperación de contraseña
          },
          child: const Text(
            '¿Olvidaste tu contraseña?',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _handleLogin,
      child: const Text(
        'Iniciar Sesión',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.borderColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppConstants.paddingM),
          child: Text(
            'O continúa con',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textLight,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColors.borderColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implementar login con Google
            },
            icon: const Icon(Icons.g_translate),
            label: const Text('Google'),
          ),
        ),
        const SizedBox(width: AppConstants.paddingS),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implementar login con Facebook
            },
            icon: const Icon(Icons.facebook),
            label: const Text('Facebook'),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '¿No tienes una cuenta? ',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textGrey,
          ),
        ),
        GestureDetector(
          onTap: () {
            // TODO: Navegar a pantalla de registro
          },
          child: const Text(
            'Regístrate aquí',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.primaryDark,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
