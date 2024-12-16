import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/budget/presentation/pages/budget_page.dart' as budget;
import 'package:spend_wise/features/group/presentation/pages/categories_page.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_states.dart';

class GroupDetailPage extends StatelessWidget {
  final AppGroup group;

  const GroupDetailPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GroupCubit(groupRepo: context.read<GroupRepository>())..getMembers(groupUid: group.uid),
      child: BlocListener<GroupInviteCubit, GroupInviteState>(
        listener: (context, state) {
          if (state is GroupInviteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
            );
          } else if (state is GroupInviteSent) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          }
        },
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
              IconButton(
                icon: const Icon(Icons.attach_money),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => budget.BudgetPage(groupId: group.uid),
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<GroupCubit, GroupState>(
            builder: (context, state) {
              if (state is GroupLoading) {
                print(group.uid);
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
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'category_fab', // Assign unique heroTag
                onPressed: () {
                  // Navigate to Categories page for this group
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoriesPage(groupId: group.uid), // Implement CategoriesPage
                    ),
                  );
                },
                child: const Icon(Icons.category),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'invite_fab', // Assign unique heroTag
                onPressed: () {
                  _showInviteDialog(context, group.uid);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
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
