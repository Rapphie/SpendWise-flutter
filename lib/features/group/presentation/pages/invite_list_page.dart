import 'package:flutter/material.dart';
import 'package:spend_wise/features/group/domain/entities/group_invite.dart';
import 'package:spend_wise/features/group/data/invite_repo_impl.dart';

class InviteListPage extends StatelessWidget {
  const InviteListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invites'),
      ),
      body: FutureBuilder<List<GroupInvite>>(
        future: InviteRepoImpl().getUserInvites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No invites'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                final invite = snapshot.data![index];
                return ListTile(
                  title: Text(invite.groupName),
                  subtitle: Text('Invited by ${invite.senderUid}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          InviteRepoImpl().acceptInvite(inviteUid: invite.id);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          InviteRepoImpl().declineInvite(inviteUid: invite.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}