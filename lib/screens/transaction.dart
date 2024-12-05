import 'package:flutter/material.dart';
import 'package:spend_wise/controllers/remote/user_controller.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
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
