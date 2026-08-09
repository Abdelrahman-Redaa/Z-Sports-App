import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:z_sports_booking/features/auth/presentation/forgot_password_screen.dart';
import 'package:z_sports_booking/features/auth/presentation/login_screen.dart';
import 'package:z_sports_booking/features/auth/presentation/otp_screen.dart';
import 'package:z_sports_booking/features/auth/presentation/register_screen.dart';
import 'package:z_sports_booking/features/auth/presentation/reset_password_screen.dart';
import 'package:z_sports_booking/features/auth/presentation/welcome_screen.dart';
import 'package:z_sports_booking/features/booking/presentation/booking_checkout_screen.dart';
import 'package:z_sports_booking/features/booking/presentation/booking_detail_screen.dart';
import 'package:z_sports_booking/features/booking/presentation/booking_screen.dart';
import 'package:z_sports_booking/features/booking/presentation/booking_success_screen.dart';
import 'package:z_sports_booking/features/chat/presentation/chat_detail_screen.dart';
import 'package:z_sports_booking/features/chat/presentation/chat_list_screen.dart';
import 'package:z_sports_booking/features/favorites/presentation/favorites_screen.dart';
import 'package:z_sports_booking/features/home/presentation/home_screen.dart';
import 'package:z_sports_booking/features/my_bookings/presentation/my_bookings_screen.dart';
import 'package:z_sports_booking/features/notifications/presentation/notifications_screen.dart';
import 'package:z_sports_booking/features/pitch/presentation/pitch_details_screen.dart';
import 'package:z_sports_booking/features/profile/presentation/edit_profile_screen.dart';
import 'package:z_sports_booking/features/profile/presentation/profile_screen.dart';
import 'package:z_sports_booking/features/profile/presentation/settings_screen.dart';
import 'package:z_sports_booking/features/profile/presentation/change_password_screen.dart';
import 'package:z_sports_booking/features/search/presentation/search_screen.dart';
import 'package:z_sports_booking/features/shell/presentation/main_shell.dart';
import 'package:z_sports_booking/features/splash/presentation/splash_screen.dart';

abstract final class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const register = '/register';
  static const otp = '/otp';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const search = '/search';
  static const favorites = '/favorites';
  static const bookings = '/bookings';
  static const profile = '/profile';
  static const pitchDetails = '/pitch/:id';
  static const booking = '/pitch/:id/book';
  static const bookingCheckout = '/pitch/:id/checkout';
  static const bookingSuccess = '/booking-success';
  static const bookingDetail = '/booking-detail';
  static const editProfile = '/edit-profile';
  static const settings = '/settings';
  static const changePassword = '/change-password';
  static const notifications = '/notifications';
  static const chat = '/chat';
  static const chatDetail = '/chat/:id';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
    GoRoute(path: AppRoutes.welcome, builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.otp,
      builder: (_, state) =>
          OtpScreen(phone: state.uri.queryParameters['phone'] ?? ''),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (_, __) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (_, state) => ResetPasswordScreen(
        email: state.uri.queryParameters['email'],
        otp: state.uri.queryParameters['otp'],
      ),
    ),
    GoRoute(
      path: AppRoutes.pitchDetails,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          PitchDetailsScreen(pitchId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.booking,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          BookingScreen(pitchId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.bookingCheckout,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) => BookingCheckoutScreen(
        pitchId: state.pathParameters['id']!,
        date: state.uri.queryParameters['date'] ?? '',
        time: state.uri.queryParameters['time'] ?? '',
      ),
    ),
    GoRoute(
      path: AppRoutes.bookingSuccess,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const BookingSuccessScreen(),
    ),
    GoRoute(
      path: AppRoutes.bookingDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) {
        final extra = state.extra as Map<String, String>? ?? {};
        return BookingDetailScreen(
          pitchName: extra['pitchName'] ?? '',
          pitchImage: extra['pitchImage'] ?? '',
          date: extra['date'] ?? '',
          time: extra['time'] ?? '',
          price: extra['price'] ?? '',
          bookingId: extra['bookingId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editProfile,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const EditProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ChangePasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.chat,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ChatListScreen(),
    ),
    GoRoute(
      path: AppRoutes.chatDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, state) =>
          ChatDetailScreen(conversationId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.search,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const SearchScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (_, __, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, __) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.bookings,
              builder: (_, __) => const MyBookingsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (_, __) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (_, __) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
