import 'package:flutter/material.dart';
import 'package:spend_wise/features/home/data/home_repo_impl.dart';
import 'package:spend_wise/utils/dateformatter.dart';
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';
import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';

class AllRecentTransactionsPage extends StatelessWidget {
  final String userUid;
  AllRecentTransactionsPage({super.key, required this.userUid});

  final HomeRepoImpl homeRepository = HomeRepoImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recent Transactions'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: homeRepository.recentTransactions(userUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recent transactions found.'));
          } else {
            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                if (transaction is AppBudget) {
                  return ListTile(
                    title: Text(transaction.categoryName, style: const TextStyle(fontSize: 18)),
                    subtitle: Text(fromTimestamp(transaction.createdOn),
                        style: const TextStyle(fontSize: 14)),
                    trailing: Text(
                      'P${transaction.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.green),
                    ),
                  );
                } else if (transaction is AppExpense) {
                  return ListTile(
                    title: Text(transaction.categoryName, style: const TextStyle(fontSize: 18)),
                    subtitle: Text(fromTimestamp(transaction.createdOn),
                        style: const TextStyle(fontSize: 14)),
                    trailing: Text(
                      'P${transaction.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  );
                } else {
                  return const ListTile(
                    title: Text('Unknown'),
                    subtitle: Text(''),
                    trailing: Text(''),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
