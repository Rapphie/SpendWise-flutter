import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'group_states.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository groupRepo;

  GroupCubit({required this.groupRepo}) : super(GroupInitial());

  Future<void> createGroup({required String name}) async {
    try {
      emit(GroupLoading());
      await groupRepo.createGroup(name: name);
      emit(GroupCreated(message: 'Group created successfully!'));
      await loadUserGroups();
    } catch (e) {
      emit(GroupError(message: 'Error: $e'));
    }
  }

  Future<void> loadUserGroups() async {
    try {
      emit(GroupLoading());
      final groups = await groupRepo.getUserGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupError(message: 'Error: $e'));
    }
  }

  Future<void> deleteGroup({required String groupUid}) async {
    try {
      emit(GroupLoading());
      await groupRepo.deleteGroup(groupUid: groupUid);
      // Optionally, reload the list of groups
      await loadUserGroups();
    } catch (e) {
      emit(GroupError(message: 'Failed to delete group: $e'));
    }
  }

  Future<void> updateGroupName({required String groupUid, required String newName}) async {
    try {
      emit(GroupLoading());
      await groupRepo.updateGroup(groupUid: groupUid, newName: newName);
      emit(GroupUpdated(message: "Group updated successfully!"));
    } catch (e) {
      emit(GroupError(message: 'Failed to update group name: $e'));
    }
  }

  Future<void> getMembers({required String groupUid}) async {
    try {
      emit(GroupLoading());
      final members = await groupRepo.getMembers(groupUid: groupUid);
      emit(GroupMembersLoaded(members: members ?? []));
    } catch (e) {
      emit(GroupError(message: 'Failed to load group members: $e'));
    }
  }

  void clearGroups() {
    emit(GroupsLoaded(groups: []));
  }
}
