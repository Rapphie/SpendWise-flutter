import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';

abstract class BudgetRepository {
  Future<AppBudget?> createBudget({required String name, required String groupUid});
  Future<AppBudget?> updateBudget({required String uid, required String groupUid, String? name, double? value});
  Future<void> getGroupBudget({required String groupUid, required String memberUid});
  Future<void> deleteBudget({required String groupUid});
}
