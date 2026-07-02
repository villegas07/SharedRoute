import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/themes/app_theme.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  final authViewModel = sl<AuthViewModel>();
  await authViewModel.checkAuth();
  runApp(SharedRouteApp(authViewModel: authViewModel));
}

class SharedRouteApp extends StatefulWidget {
  final AuthViewModel authViewModel;

  const SharedRouteApp({super.key, required this.authViewModel});

  @override
  State<SharedRouteApp> createState() => _SharedRouteAppState();
}

class _SharedRouteAppState extends State<SharedRouteApp> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(widget.authViewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.authViewModel,
      child: MaterialApp.router(
        title: 'SharedRoute',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
