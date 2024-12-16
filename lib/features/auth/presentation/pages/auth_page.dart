import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/auth/presentation/pages/swipeable_screens.dart';
import 'package:spend_wise/features/home/presentation/pages/my_home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AppUser? _currentUser;
  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const OnboardingSwipeScreens();
    } else {
      return const MyHomePage();
    }
  }
}
