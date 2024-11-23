import 'package:spend_wise/controllers/auth_controller.dart';
import 'package:spend_wise/views/home.dart';
import 'package:go_router/go_router.dart';
import 'package:spend_wise/views/login.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthenticationController(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
