import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../features/auth/presentation/viewmodels/auth_viewmodel.dart';
import '../../features/auth/presentation/viewmodels/forgot_password_viewmodel.dart';
import '../../features/auth/presentation/viewmodels/register_viewmodel.dart';
import '../../features/auth/presentation/views/forgot_password_view.dart';
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_view.dart';
import '../../features/bookings/presentation/viewmodels/booking_viewmodel.dart';
import '../../features/bookings/presentation/viewmodels/bookings_list_viewmodel.dart';
import '../../features/bookings/presentation/views/booking_detail_view.dart';
import '../../features/bookings/presentation/views/bookings_view.dart';
import '../../features/geolocation/presentation/viewmodels/places_viewmodel.dart';
import '../../features/home/presentation/views/home_view.dart';
import '../../features/home/presentation/views/main_scaffold.dart';
import '../../features/profile/presentation/viewmodels/profile_viewmodel.dart';
import '../../features/profile/presentation/views/edit_profile_view.dart';
import '../../features/profile/presentation/views/profile_view.dart';
import '../../features/trips/presentation/viewmodels/trip_detail_viewmodel.dart';
import '../../features/trips/presentation/viewmodels/trip_search_viewmodel.dart';
import '../../features/trips/presentation/views/trip_detail_view.dart';
import '../../features/trips/presentation/views/trip_search_view.dart';
import '../../injection_container.dart';
import 'app_routes.dart';

final class AppRouter {
  final AuthViewModel _authViewModel;

  AppRouter(this._authViewModel);

  late final GoRouter router = GoRouter(
    refreshListenable: _authViewModel,
    initialLocation: AppRoutes.home,
    redirect: _guard,
    routes: [
      ..._publicRoutes,
      ..._topLevelRoutes,
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) =>
            MainScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: _homeBranch),
          StatefulShellBranch(routes: _searchBranch),
          StatefulShellBranch(routes: _bookingsBranch),
          StatefulShellBranch(routes: _profileBranch),
        ],
      ),
    ],
  );

  String? _guard(BuildContext context, GoRouterState state) {
    final isAuthenticated =
        _authViewModel.status == AuthStatus.authenticated;
    final isUnauthenticated =
        _authViewModel.status == AuthStatus.unauthenticated;

    const publicPaths = [
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.forgotPassword,
    ];
    final isOnPublicRoute = publicPaths.contains(state.matchedLocation);

    if (isUnauthenticated && !isOnPublicRoute) return AppRoutes.login;
    if (isAuthenticated && isOnPublicRoute) return AppRoutes.home;
    return null;
  }

  List<RouteBase> get _publicRoutes => [
        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const LoginView(),
        ),
        GoRoute(
          path: AppRoutes.register,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<RegisterViewModel>(),
            child: const RegisterView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<ForgotPasswordViewModel>(),
            child: const ForgotPasswordView(),
          ),
        ),
      ];

  // Detail screens overlay the full shell (no bottom nav).
  List<RouteBase> get _topLevelRoutes => [
        GoRoute(
          path: AppRoutes.tripDetail,
          builder: (context, state) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => sl<TripDetailViewModel>()),
              ChangeNotifierProvider(create: (_) => sl<BookingViewModel>()),
            ],
            child:
                TripDetailView(tripId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.bookingDetail,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<BookingsListViewModel>(),
            child: BookingDetailView(
                bookingId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<ProfileViewModel>()..loadProfile(),
            child: const EditProfileView(),
          ),
        ),
      ];

  List<RouteBase> get _homeBranch => [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<BookingsListViewModel>(),
            child: const HomeView(),
          ),
        ),
      ];

  List<RouteBase> get _searchBranch => [
        GoRoute(
          path: AppRoutes.searchTrips,
          builder: (context, state) => MultiProvider(
            providers: [
              ChangeNotifierProvider(
                  create: (_) => sl<TripSearchViewModel>()),
              ChangeNotifierProvider(create: (_) => sl<PlacesViewModel>()),
            ],
            child: const TripSearchView(),
          ),
        ),
      ];

  List<RouteBase> get _bookingsBranch => [
        GoRoute(
          path: AppRoutes.myBookings,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<BookingsListViewModel>(),
            child: const BookingsView(),
          ),
        ),
      ];

  List<RouteBase> get _profileBranch => [
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<ProfileViewModel>(),
            child: const ProfileView(),
          ),
        ),
      ];
}
