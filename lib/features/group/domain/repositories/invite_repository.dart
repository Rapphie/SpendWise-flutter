import 'package:spend_wise/features/group/domain/entities/group_invite.dart';

abstract class InviteRepository {
  Future<void> sendInvite({required String groupUid, required String userEmail});
  Future<void> acceptInvite({required String inviteUid});
  Future<void> declineInvite({required String inviteUid});
  Future<List<GroupInvite>> getUserInvites();
}
