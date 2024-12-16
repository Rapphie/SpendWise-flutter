
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseCreated extends ExpenseState {
  final String message;
  ExpenseCreated({required this.message});
}

class ExpensesLoaded extends ExpenseState {
  final List<AppExpense> expenses;
  ExpensesLoaded({required this.expenses});
}

class ExpenseUpdated extends ExpenseState {
  final String message;
  ExpenseUpdated({required this.message});
}

class ExpenseDeleted extends ExpenseState {
  final String message;
  ExpenseDeleted({required this.message});
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError({required this.message});
}