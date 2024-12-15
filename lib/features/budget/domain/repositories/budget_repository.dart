import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';

abstract class BudgetRepository {
  Future<AppBudget?> createBudget(
      {required String categoryName, required String groupId, required double amount});
  Future<AppBudget?> updateBudget(
      {required String uid, required String groupId, String? categoryName, double? amount});
  Future<void> deleteBudget({required String budgetUid});
  Future<List<AppBudget>> getGroupBudgets({required String groupId});
}
