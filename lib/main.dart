import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/themes/app_theme.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'injection_container.dart';

void main() {
  setupDependencies();
  runApp(const SharedRouteApp());
}

class SharedRouteApp extends StatelessWidget {
  const SharedRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<AuthViewModel>(),
      child: MaterialApp(
        title: 'SharedRoute',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const LoginView(),
      ),
    );
  }
}
