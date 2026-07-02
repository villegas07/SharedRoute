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
import '../../features/reviews/presentation/viewmodels/create_review_viewmodel.dart';
import '../../features/reviews/presentation/viewmodels/user_reviews_viewmodel.dart';
import '../../features/reviews/presentation/views/create_review_view.dart';
import '../../features/reviews/presentation/views/user_reviews_view.dart';
import '../../features/sos/presentation/viewmodels/add_contact_viewmodel.dart';
import '../../features/sos/presentation/viewmodels/sos_viewmodel.dart';
import '../../features/sos/presentation/views/add_emergency_contact_view.dart';
import '../../features/sos/presentation/views/sos_view.dart';
import '../../features/support/presentation/viewmodels/create_ticket_viewmodel.dart';
import '../../features/support/presentation/viewmodels/ticket_detail_viewmodel.dart';
import '../../features/support/presentation/viewmodels/tickets_list_viewmodel.dart';
import '../../features/support/presentation/views/create_ticket_view.dart';
import '../../features/support/presentation/views/support_ticket_detail_view.dart';
import '../../features/support/presentation/views/support_tickets_view.dart';
import '../../features/trip_history/presentation/viewmodels/trip_history_detail_viewmodel.dart';
import '../../features/trip_history/presentation/viewmodels/trip_history_viewmodel.dart';
import '../../features/trip_history/presentation/views/trip_history_detail_view.dart';
import '../../features/trip_history/presentation/views/trip_history_view.dart';
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
        GoRoute(
          path: AppRoutes.tripHistory,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<TripHistoryViewModel>(),
            child: const TripHistoryView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.tripHistoryDetail,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<TripHistoryDetailViewModel>(),
            child: TripHistoryDetailView(
                tripId: state.pathParameters['tripId']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.createReview,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<CreateReviewViewModel>(),
            child:
                CreateReviewView(tripId: state.pathParameters['tripId']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.userReviews,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<UserReviewsViewModel>(),
            child:
                UserReviewsView(userId: state.pathParameters['userId']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.sos,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<SosViewModel>(),
            child: const SosView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.addEmergencyContact,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<AddContactViewModel>(),
            child: const AddEmergencyContactView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.supportTickets,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<TicketsListViewModel>(),
            child: const SupportTicketsView(),
          ),
        ),
        GoRoute(
          path: AppRoutes.supportTicketDetail,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<TicketDetailViewModel>(),
            child: SupportTicketDetailView(
                ticketId: state.pathParameters['id']!),
          ),
        ),
        GoRoute(
          path: AppRoutes.createSupportTicket,
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => sl<CreateTicketViewModel>(),
            child: const CreateTicketView(),
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
