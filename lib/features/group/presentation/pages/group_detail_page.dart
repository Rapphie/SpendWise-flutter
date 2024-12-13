
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';

class GroupDetailPage extends StatelessWidget {
  final AppGroup group;

  GroupDetailPage({required this.group});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupCubit(groupRepository: context.read<GroupRepository>()),
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
        body: Column(
          children: [
            // Display group members
            Expanded(
              child: FutureBuilder(
                future: context.read<GroupRepository>().getMembers(groupuid: group.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    final members = snapshot.data as List<AppGroup>;
                    return ListView.builder(
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(members[index].name),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text('No members found.'));
                  }
                },
              ),
            ),
            // Invite member button
            ElevatedButton(
              onPressed: () {
                // Implement invite member functionality
              },
              child: Text('Invite Member'),
            ),
          ],
        ),
      ),
    );
  }
}