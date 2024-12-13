import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/presentation/pages/login_page.dart';
import 'package:spend_wise/features/auth/presentation/pages/signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      // child: showLoginPage ? const LoginPage() : SignupPage(),
    );
    // return showLoginPage ? const LoginPage(togglePages) : SignupPage(togglePages);
  }
}
