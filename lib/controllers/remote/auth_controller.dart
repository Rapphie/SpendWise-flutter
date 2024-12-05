import 'package:flutter/material.dart';
import 'package:spend_wise/screens/home.dart';
import 'package:spend_wise/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationController extends StatelessWidget {
  const AuthenticationController({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in
        if (snapshot.hasData) {
          return const TransactionScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
