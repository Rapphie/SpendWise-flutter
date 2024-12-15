import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/group/presentation/pages/group_page.dart'; // Add this import

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void logout() {
    context.read<AuthCubit>().logout();
    context.read<GroupCubit>().clearGroups();
    context.read<GroupInviteCubit>().clearInvites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully logged out'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the current auth state
    final authState = context.watch<AuthCubit>().state;
    String userName = 'Guest';
    if (authState is Authenticated) {
      userName = authState.user.name;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                if (state is GroupsLoaded) {
                  return DropdownButton<AppGroup>(
                    value: state.selectedGroup,
                    items: state.groups.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(group.name),
                      );
                    }).toList(),
                    onChanged: (AppGroup? newGroup) {
                      if (newGroup != null) {
                        context.read<GroupCubit>().setSelectedGroup(newGroup);
                      }
                    },
                  );
                } else if (state is GroupLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const SizedBox();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupPage()),
                );
              },
              child: const Text('Go to Group Page'),
            ),
            ElevatedButton(
              onPressed: () {
                final groupCubit = context.read<GroupCubit>();
                if (groupCubit.selectedGroup != null) {
                  // Navigate to Categories page for selectedGroup
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No group selected!'),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
              child: const Text('Categories'),
            ),
            Text('Welcome, $userName'),
          ],
        ),
      ),
    );
  }
}
