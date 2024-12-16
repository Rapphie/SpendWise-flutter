import 'package:spend_wise/features/auth/domain/entities/app_user.dart';

import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';
import 'package:spend_wise/features/home/domain/repositories/home_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeRepoImpl implements HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<List> getRecentTransactions(String userid) async {
    final budgets = await fetchBudgets(userid);
    final expenses = await fetchExpenses(userid);
    final transactions = <dynamic>[];
    transactions.addAll(budgets);
    transactions.addAll(expenses);
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.toList();
  }

  Future<List<dynamic>> recentTransactions(String userid) async {
    final budgets = await fetchBudgets(userid);
    final expenses = await fetchExpenses(userid);
    final transactions = <dynamic>[];
    transactions.addAll(budgets);
    transactions.addAll(expenses);
    transactions.sort((a, b) => b.createdOn.compareTo(a.createdOn));
    return transactions.toList();
  }

  Future<List<AppBudget>> fetchBudgets(String userid) async {
    final snapshot =
        await _firestore.collection('budgets').where('userId', isEqualTo: userid).get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return AppBudget.fromJson(data);
    }).toList();
  }

  Future<List<AppExpense>> fetchExpenses(String userid) async {
    final snapshot =
        await _firestore.collection('expenses').where('userId', isEqualTo: userid).get();
    return snapshot.docs.map((doc) => AppExpense.fromJson(doc.data())).toList();
  }
}
