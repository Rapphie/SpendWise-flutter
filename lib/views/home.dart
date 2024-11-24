import 'package:flutter/material.dart';
import 'package:spend_wise/controllers/user_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final UserController userController = UserController();

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
