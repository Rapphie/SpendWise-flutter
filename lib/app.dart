import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/data/auth_repo_impl.dart';
import 'package:spend_wise/features/auth/domain/repositories/auth_repository.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';
import 'package:spend_wise/features/auth/presentation/pages/auth_page.dart';
import 'package:spend_wise/features/group/data/group_repo_impl.dart';
import 'package:spend_wise/features/group/data/invite_repo_impl.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'package:spend_wise/features/group/domain/repositories/invite_repository.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GroupRepository>(
          create: (context) => GroupRepoImpl(),
        ),
        RepositoryProvider<InviteRepository>(
          create: (context) => InviteRepoImpl(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepoImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthCubit(authRepo: context.read<AuthRepository>())..checkAuth(),
          ),
          BlocProvider(
            create: (context) =>
                GroupCubit(groupRepo: context.read<GroupRepository>())..loadUserGroups(),
          ),
          BlocProvider(
            create: (context) =>
                GroupInviteCubit(inviteRepo: context.read<InviteRepository>())..loadInvites(),
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
              if (state is Authenticated) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ));
              }
              if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ));
              }
            },
          ),
        ),
      ),
    );
  }
}
