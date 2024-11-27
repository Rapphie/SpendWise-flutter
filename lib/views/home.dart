import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/controllers/remote/user_controller.dart';
import 'package:spend_wise/widgets/components/snackbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  final UserController userController = UserController();

  @override
  void initState() {
    super.initState();
    Snackbar.showSnackBar("Successfully signed in as ${user.email}",
        duration: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Home"),
            ElevatedButton(
              onPressed: userController.logoutUser, // Fixed issue here
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
