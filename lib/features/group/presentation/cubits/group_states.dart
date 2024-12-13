import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;
  Authenticated({required this.user});
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

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

class GroupInviteSent extends GroupState {}

class GroupInviteAccepted extends GroupState {}

class GroupError extends GroupState {
  final String message;
  GroupError({required this.message});
}
