import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_states.dart';
import 'package:spend_wise/utils/dateformatter.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GroupInviteCubit>().loadInvites();

    return BlocListener<GroupInviteCubit, GroupInviteState>(
      listener: (context, state) {
        if (state is GroupInviteAccepted) {
          context.read<GroupCubit>().loadUserGroups(); // Reload user groups
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        } else if (state is GroupInviteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Invites'),
        ),
        body: BlocBuilder<GroupInviteCubit, GroupInviteState>(
          builder: (context, state) {
            if (state is InvitesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is InvitesLoaded) {
              final invites = state.invites;
              if (invites.isEmpty) {
                return const Center(child: Text('No invites found.'));
              }
              return ListView.builder(
                itemCount: invites.length,
                itemBuilder: (context, index) {
                  final invite = invites[index];
                  return ListTile(
                    title: Text('Group: ${invite.groupName}'),
                    isThreeLine: true,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Invited by: ${invite.senderName}'),
                        const SizedBox(height: 5),
                        Text(
                          fromTimestamp(invite.sentOn),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          onPressed: () {
                            context.read<GroupInviteCubit>().acceptInvite(
                                  inviteUid: invite.id,
                                );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            context.read<GroupInviteCubit>().declineInvite(inviteUid: invite.id);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is GroupInviteError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('No invites found.'));
            }
          },
        ),
      ),
    );
  }
}
