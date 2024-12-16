import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'group_states.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository groupRepo;
  AppGroup? selectedGroup;
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

  Future<void> addCategory({required String groupUid, required String categoryName}) async {
    try {
      emit(GroupLoading());
      await groupRepo.createCategory(groupUid: groupUid, categoryName: categoryName);
      emit(GroupUpdated(message: 'Category added successfully!'));
      // Reload groups to update the UI
      await loadUserGroups();
    } catch (e) {
      emit(GroupError(message: 'Failed to add category: $e'));
    }
  }

  Future<void> loadUserGroups() async {
    try {
      emit(GroupLoading());
      final groups = await groupRepo.getUserGroups();
      if (groups.isNotEmpty) {
        selectedGroup = groups.firstWhere(
          (group) => group.name == 'Personal',
          orElse: () => groups.first,
        );
      } else {
        selectedGroup = null;
      }
      emit(GroupsLoaded(
          groups: groups, selectedGroup: selectedGroup)); // Changed from null to selectedGroup
    } catch (e) {
      emit(GroupError(message: 'Error: $e'));
    }
  }

  Future<void> deleteGroup({required String groupUid}) async {
    try {
      emit(GroupLoading());
      await groupRepo.deleteGroup(groupUid: groupUid);
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

  Future<List<String>?> getCategories({required String groupUid}) async {
    try {
      emit(GroupLoading());
      final categories = await groupRepo.getCategories(groupUid: groupUid);
      return categories!.cast<String>().toList();
    } catch (e) {
      emit(GroupError(message: 'Failed to load group members: $e'));
    }
    return null;
  }

  void clearGroups() {
    emit(GroupsLoaded(groups: [], selectedGroup: null));
  }

  void clearMembers() {
    emit(GroupMembersLoaded(members: []));
  }

  void setSelectedGroup(AppGroup group) {
    selectedGroup = group;
    if (state is GroupsLoaded) {
      final currentState = state as GroupsLoaded;
      emit(GroupsLoaded(groups: currentState.groups, selectedGroup: group));
    }
  }
}
