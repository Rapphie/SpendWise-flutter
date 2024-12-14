import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'group_states.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository groupRepository;

  GroupCubit({required this.groupRepository}) : super(GroupInitial());

  Future<void> createGroup({required String name}) async {
    try {
      emit(GroupLoading());
      final group = await groupRepository.createGroup(name: name);
      emit(GroupCreated(group: group));
    } catch (e) {
      emit(GroupError(message: 'Error: $e'));
    }
  }

  Future<void> loadUserGroups() async {
    try {
      emit(GroupLoading());
      final groups = await groupRepository.getUserGroups();
      emit(GroupsLoaded(groups: groups));
    } catch (e) {
      emit(GroupError(message: 'Error: $e'));
    }
  }

  Future<void> deleteGroup({required String groupUid}) async {
    try {
      emit(GroupLoading());
      await groupRepository.deleteGroup(groupUid: groupUid);
      // Optionally, reload the list of groups
      await loadUserGroups();
    } catch (e) {
      emit(GroupError(message: 'Failed to delete group: $e'));
    }
  }

  Future<void> updateGroupName({required String groupUid, required String newName}) async {
    try {
      emit(GroupLoading());
      await groupRepository.updateGroup(groupUid: groupUid, newName: newName);
      emit(GroupUpdated(message: "Group updated successfully!"));
    } catch (e) {
      emit(GroupError(message: 'Failed to update group name: $e'));
    }
  }
}
