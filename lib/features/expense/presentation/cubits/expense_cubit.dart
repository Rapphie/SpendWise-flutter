
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expense/domain/repositories/expense_repository.dart';
import 'expense_states.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository expenseRepo;

  ExpenseCubit({required this.expenseRepo}) : super(ExpenseInitial());

  Future<void> createExpense({required String groupId, required String categoryName, required double amount}) async {
    try {
      emit(ExpenseLoading());
      await expenseRepo.createExpense(groupId: groupId, categoryName: categoryName, amount: amount);
      emit(ExpenseCreated(message: 'Expense created successfully!'));
      await loadExpenses(groupId: groupId);
    } catch (e) {
      emit(ExpenseError(message: 'Failed to create expense: $e'));
    }
  }

  Future<void> updateExpense({required String uid, required String groupId, String? categoryName, double? amount}) async {
    try {
      emit(ExpenseLoading());
      await expenseRepo.updateExpense(uid: uid, groupId: groupId, categoryName: categoryName, amount: amount);
      emit(ExpenseUpdated(message: 'Expense updated successfully!'));
      await loadExpenses(groupId: groupId);
    } catch (e) {
      emit(ExpenseError(message: 'Failed to update expense: $e'));
    }
  }

  Future<void> deleteExpense({required String expenseUid, required String groupId}) async {
    try {
      emit(ExpenseLoading());
      await expenseRepo.deleteExpense(expenseUid: expenseUid);
      emit(ExpenseDeleted(message: 'Expense deleted successfully!'));
      await loadExpenses(groupId: groupId);
    } catch (e) {
      emit(ExpenseError(message: 'Failed to delete expense: $e'));
    }
  }

  Future<void> loadExpenses({required String groupId}) async {
    try {
      emit(ExpenseLoading());
      final expenses = await expenseRepo.getGroupExpenses(groupId: groupId);
      emit(ExpensesLoaded(expenses: expenses));
    } catch (e) {
      emit(ExpenseError(message: 'Failed to load expenses: $e'));
    }
  }
}