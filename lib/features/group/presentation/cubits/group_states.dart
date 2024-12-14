import 'package:spend_wise/features/group/domain/entities/app_group.dart';

abstract class GroupState {}

class GroupInitial extends GroupState {}

class GroupLoading extends GroupState {}

class GroupCreated extends GroupState {
  final AppGroup group;
  GroupCreated({required this.group});
}

class GroupsLoaded extends GroupState {
  final List<AppGroup> groups;
  GroupsLoaded({required this.groups});
}

class GroupUpdated extends GroupState {
  final String message;
  GroupUpdated({required this.message});
}

class GroupError extends GroupState {
  final String message;
  GroupError({required this.message});
}
