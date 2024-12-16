
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';

abstract class ExpenseRepository {
  Future<AppExpense?> createExpense({required String categoryName, required String groupId, required double amount});
  Future<AppExpense?> updateExpense({required String uid, required String groupId, String? categoryName, double? amount});
  Future<void> deleteExpense({required String expenseUid});
  Future<List<AppExpense>> getGroupExpenses({required String groupId});
}