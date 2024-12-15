import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';


abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetCreated extends BudgetState {
  final String message;
  BudgetCreated({required this.message});
}

class BudgetsLoaded extends BudgetState {
  final List<AppBudget> budgets;
  BudgetsLoaded({required this.budgets});
}

class BudgetUpdated extends BudgetState {
  final String message;
  BudgetUpdated({required this.message});
}

class BudgetDeleted extends BudgetState {
  final String message;
  BudgetDeleted({required this.message});
}

class BudgetError extends BudgetState {
  final String message;
  BudgetError({required this.message});
}
