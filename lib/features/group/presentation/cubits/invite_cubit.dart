import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/domain/repositories/invite_repository.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_states.dart';

class GroupInviteCubit extends Cubit<GroupInviteState> {
  final InviteRepository inviteRepo;

  GroupInviteCubit({required this.inviteRepo}) : super(InvitesLoading());

  Future<void> sendInvite({required String groupUid, required String memberUid}) async {
    try {
      emit(InvitesLoading());
      await inviteRepo.sendInvite(groupUid: groupUid, memberUid: memberUid);
      emit(GroupInviteSent());
    } catch (e) {
      emit(GroupInviteError(message: 'Failed to send invite: $e'));
    }
  }
  Future<void> loadInvites() async {
    try {
      emit(InvitesLoading());
      final invites = await inviteRepo.getUserInvites();
      emit(InvitesLoaded(invites: invites));
    } catch (e) {
      emit(GroupInviteError(message: 'Error: $e'));
    }
  }

  Future<void> acceptInvite({required String inviteUid}) async {
    try {
      emit(InvitesLoading());
      await inviteRepo.acceptInvite(inviteUid: inviteUid);
      emit(GroupInviteAccepted());
    } catch (e) {
      emit(GroupInviteError(message: 'Failed to accept invite: $e'));
    }
  }

  Future<void> declineInvite({required String inviteUid}) async {
    try {
      emit(InvitesLoading());
      await inviteRepo.declineInvite(inviteUid: inviteUid);
      emit(GroupInviteDeclined());
    } catch (e) {
      emit(GroupInviteError(message: 'Failed to decline invite: $e'));
    }
  }
}
