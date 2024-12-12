import 'package:spend_wise/controllers/remote/auth_controller.dart';
import 'package:spend_wise/screens/home.dart';
import 'package:go_router/go_router.dart';
import 'package:spend_wise/screens/auth/login.dart';
import 'package:spend_wise/screens/auth/signup.dart';
import 'package:spend_wise/screens/home_page.dart';

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
      builder: (context, state) => const HomePage(),
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
