import 'package:spend_wise/features/invite/domain/entities/group_invite.dart';

abstract class GroupInviteState {}

class GroupInviteSent extends GroupInviteState {
  final String message;
  GroupInviteSent({required this.message});
}

class InvitesLoading extends GroupInviteState {}

class InvitesLoaded extends GroupInviteState {
  final List<GroupInvite> invites;
  InvitesLoaded({required this.invites});
}

class GroupInviteAccepted extends GroupInviteState {
  final String message;
  GroupInviteAccepted({required this.message});
}

class GroupInviteDeclined extends GroupInviteState {}

class GroupInviteError extends GroupInviteState {
  final String message;
  GroupInviteError({required this.message});
}
