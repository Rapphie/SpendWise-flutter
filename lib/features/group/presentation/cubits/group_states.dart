import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupCreated extends GroupState {
  final String message;
  GroupCreated({required this.message});
}

class GroupsLoaded extends GroupState {
  final List<AppGroup> groups;
  final AppGroup? selectedGroup; // Add this field

  GroupsLoaded({required this.groups, required this.selectedGroup});
}

class GroupUpdated extends GroupState {
  final String message;
  GroupUpdated({required this.message});
}

class GroupError extends GroupState {
  final String message;
  GroupError({required this.message});
}

class GroupMembersLoaded extends GroupState {
  final List<AppUser?> members;
  GroupMembersLoaded({required this.members});
}
