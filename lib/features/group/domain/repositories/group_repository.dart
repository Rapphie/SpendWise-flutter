import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/domain/entities/group_invite.dart';

abstract class GroupRepository {
  Future<AppGroup> createGroup({required String name});
  Future<AppGroup> updateGroup({required String groupUid, required String newName});
  Future<void> deleteGroup({required String groupUid});
  Future<List<AppUser>?> getMembers({required String groupUid});
  Future<List<AppGroup>> getUserGroups();
  Future<List<String>?> getCategories({required String groupUid});
}
