import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/auth/presentation/pages/swipeable_screens.dart';
import 'package:spend_wise/features/home/presentation/pages/my_home_page.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check if the user is logged in
        if (snapshot.hasData) {
          print("display name is: ${snapshot.data!.email}");
          Navigator.pop(context);
          return const MyHomePage();
        } else {
          return const OnboardingSwipeScreens();
        }
      },
    );
  }
}
