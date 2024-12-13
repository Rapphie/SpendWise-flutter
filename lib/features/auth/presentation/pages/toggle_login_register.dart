import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/presentation/pages/login_page.dart';
import 'package:spend_wise/features/auth/presentation/pages/signup_page.dart';

class ToggleLoginRegister extends StatefulWidget {
  const ToggleLoginRegister({super.key});

  @override
  State<ToggleLoginRegister> createState() => _ToggleLoginRegisterState();
}

class _ToggleLoginRegisterState extends State<ToggleLoginRegister> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages);
    } else {
      return SignupPage(onTap: togglePages);
    }
  }
}
