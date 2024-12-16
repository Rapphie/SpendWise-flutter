import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/budget/domain/repositories/budget_repository.dart';
import 'budget_states.dart';

class BudgetCubit extends Cubit<BudgetState> {
  final BudgetRepository budgetRepo;

  BudgetCubit({required this.budgetRepo}) : super(BudgetInitial());

  Future<void> createBudget(
      {required String groupId, required String name, required double amount}) async {
    try {
      emit(BudgetLoading());
      await budgetRepo.createBudget(groupId: groupId, categoryName: name, amount: amount);
      emit(BudgetCreated(message: 'Budget created successfully!')); // Emits BudgetCreated
      await loadBudgets(groupId: groupId);
      emit(BudgetInitial());
    } catch (e) {
      emit(BudgetError(message: 'Failed to create budget: $e')); // Emits BudgetError
    }
  }

  Future<void> updateBudget(
      {required String uid, required String groupId, double? amount, String? categoryName}) async {
    try {
      emit(BudgetLoading());
      await budgetRepo.updateBudget(
          uid: uid, groupId: groupId, amount: amount, categoryName: categoryName);
      emit(BudgetUpdated(message: 'Budget updated successfully!'));
      await loadBudgets(groupId: groupId);
    } catch (e) {
      emit(BudgetError(message: 'Failed to update budget: $e'));
    }
  }

  void deleteBudget({required String budgetUid, required String groupId}) async {
    try {
      emit(BudgetLoading());
      await budgetRepo.deleteBudget(budgetUid: budgetUid);
      emit(BudgetDeleted(message: 'Budget deleted successfully!'));
      await loadBudgets(groupId: groupId);
    } catch (e) {
      emit(BudgetError(message: 'Failed to delete budget: $e'));
    }
  }

  Future<void> loadBudgets({required String groupId}) async {
    try {
      emit(BudgetLoading());
      final budgets = await budgetRepo.getGroupBudgets(groupId: groupId);
      emit(BudgetsLoaded(budgets: budgets));
    } catch (e) {
      emit(BudgetError(message: 'Failed to load budgets: $e'));
    }
  }
}
