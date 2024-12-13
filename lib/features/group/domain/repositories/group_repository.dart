import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';

abstract class GroupRepository {
  Future<AppGroup?> createGroup({required String name});
  Future<List<AppGroup>?> getMembers({required String groupuid});
  Future<List<String>?> getCategories({required String groupuid});
  Future<void> deleteGroup({required String groupuid});
  Future<void> inviteMember({required String groupUid, required String memberUid});
  Future<void> acceptInvite({required String groupUid, required String memberUid});
  Future<List<AppGroup>> getUserGroups();
}
