import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_states.dart';

class InvitesPage extends StatelessWidget {
  const InvitesPage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<GroupInviteCubit>().loadInvites();

    return Scaffold(
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
                  subtitle: Text('Invited by: ${invite.senderName}'),
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
    );
  }
}
