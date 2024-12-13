import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/data/firebase_auth_repository.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';
import 'package:spend_wise/features/auth/presentation/pages/auth_page.dart';
import 'package:spend_wise/features/group/data/firebase_group_repo.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final authRepo = FirebaseAuthRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GroupRepository>(
          create: (context) => FirebaseGroupRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
          ),
          BlocProvider(
            create: (context) =>
                GroupCubit(groupRepository: context.read<GroupRepository>())..loadUserGroups(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              print(authState);

              if (authState is Authenticated) {
                return const HomePage();
              } else if (authState is Unauthenticated) {
                return const AuthPage();
              } else {
                return const Scaffold(body: Center(child: CircularProgressIndicator()));
              }
            },
            listener: (context, state) {
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ),
      ),
    );
  }
}
