import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/data/firebase_auth_repository.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';
import 'package:spend_wise/features/auth/presentation/pages/auth_page.dart';
import 'package:spend_wise/features/auth/presentation/pages/toggle_login_register.dart';
import 'package:spend_wise/features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = FirebaseAuthRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: BlocConsumer<AuthCubit, AuthState>(builder: (context, authState) {
              print(authState);

              if (authState is Authenticated) {
                return const HomePage();
              } else if (authState is Unauthenticated) {
                return const AuthPage();
              } else {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
            }, listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            })));
  }
}
