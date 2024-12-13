import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';
import 'group_states.dart';

class GroupCubit extends Cubit<GroupState> {
  final GroupRepository groupRepository;

  GroupCubit({required this.groupRepository}) : super(GroupInitial());

  Future<void> createGroup({required String name}) async {
    try {
      emit(GroupLoading());
      final group = await groupRepository.createGroup(name: name);
      if (group != null) {
        emit(GroupCreated(group: group));
      } else {
        emit(GroupError(message: 'Failed to create group.'));
      }
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

  Future<void> inviteMember({required String groupUid, required String memberUid}) async {
    try {
      await groupRepository.inviteMember(groupUid: groupUid, memberUid: memberUid);
      emit(GroupInviteSent());
    } catch (e) {
      emit(GroupError(message: 'Failed to invite member: $e'));
    }
  }

  Future<void> acceptInvite({required String groupUid, required String memberUid}) async {
    try {
      await groupRepository.acceptInvite(groupUid: groupUid, memberUid: memberUid);
      emit(GroupInviteAccepted());
    } catch (e) {
      emit(GroupError(message: 'Failed to accept invite: $e'));
    }
  }

  Future<void> deleteGroup({required String groupUid}) async {
    try {
      emit(GroupLoading());
      await groupRepository.deleteGroup(groupuid: groupUid);
      // Optionally, reload the list of groups
      await loadUserGroups();
    } catch (e) {
      emit(GroupError(message: 'Failed to delete group: $e'));
    }
  }
}
