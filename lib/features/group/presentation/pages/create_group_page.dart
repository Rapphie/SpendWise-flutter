import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';

class CreateGroupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  CreateGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupCubit, GroupState>(
      listener: (context, state) {
        if (state is GroupCreated) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green),
          );
        } else if (state is GroupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Group'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Group Name'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<GroupCubit>().createGroup(name: _nameController.text);
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
