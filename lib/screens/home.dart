import 'package:flutter/material.dart';
import 'package:spend_wise/controllers/remote/user_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = UserController();

  @override
  void initState() {
    super.initState();
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
              onPressed: userController.logoutUser,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
