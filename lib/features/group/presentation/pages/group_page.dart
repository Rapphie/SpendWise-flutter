import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/group/presentation/pages/group_detail_page.dart';
import 'package:spend_wise/features/group/presentation/pages/invites_page.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InvitesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<GroupCubit, GroupState>(
        builder: (context, state) {
          if (state is GroupLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GroupsLoaded) {
            final groups = state.groups;
            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                print('The Group id is: ' + group.uid);
                return ListTile(
                  title: Text(group.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupDetailPage(group: group),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is GroupError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No groups found.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
