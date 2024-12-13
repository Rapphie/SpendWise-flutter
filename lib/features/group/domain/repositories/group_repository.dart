import 'package:spend_wise/features/group/domain/entities/app_group.dart';

abstract class GroupRepository {
  Future<AppGroup?> createGroup({required String name});
  Future<List<AppGroup>?> getMembers({required String groupuid});
  Future<List<String>?> getCategories({required String groupuid});
  Future<void> deleteGroup({required String groupuid});
}
