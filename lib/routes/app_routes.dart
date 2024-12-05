import 'package:spend_wise/controllers/remote/auth_controller.dart';
import 'package:spend_wise/screens/home.dart';
import 'package:go_router/go_router.dart';
import 'package:spend_wise/screens/login.dart';
import 'package:spend_wise/screens/signup.dart';

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
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignupScreen(),
    ),
  ],
);
