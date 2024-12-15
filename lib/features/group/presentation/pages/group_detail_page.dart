import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_cubit.dart';

class GroupDetailPage extends StatelessWidget {
  final AppGroup group;

  const GroupDetailPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroupCubit(groupRepo: context.read<GroupRepository>())..getMembers(groupUid: group.uid),
      child: Scaffold(
        appBar: AppBar(
          title: Text(group.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<GroupCubit>().deleteGroup(groupUid: group.uid);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<GroupCubit, GroupState>(
          builder: (context, state) {
            if (state is GroupLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GroupMembersLoaded) {
              final members = state.members;
              if (members.isEmpty) {
                return const Center(child: Text('No members found.'));
              }
              return ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(members[index]!.name),
                  );
                },
              );
            } else if (state is GroupError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No members found.'));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showInviteDialog(context, group.uid);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showInviteDialog(BuildContext context, String groupUid) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Invite Member'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter user email'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final userEmail = controller.text.trim();
                if (userEmail.isNotEmpty) {
                  context
                      .read<GroupInviteCubit>()
                      .sendInvite(groupUid: groupUid, userEmail: userEmail);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invite sent successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }
}
