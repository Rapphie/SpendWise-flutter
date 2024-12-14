import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthCubit>().logout();
              },
            )
          ],
        ),
        drawer: const Drawer(
          backgroundColor: Colors.white70,
          child: SafeArea(
              child: Column(
            children: [
              Icon(
                Icons.person,
                size: 80,
                color: Colors.black87,
              ),
              ListTile(
                title: Text("Profile"),
                onTap: ,
              ),
            ],
          )),
        ));
  }
}
