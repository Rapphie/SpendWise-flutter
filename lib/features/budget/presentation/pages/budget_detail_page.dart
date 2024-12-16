import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_cubit.dart';

class BudgetDetailPage extends StatelessWidget {
  final AppBudget budget;

  const BudgetDetailPage({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditBudgetDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              budget.categoryName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Amount: \$${budget.amount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 20),
            ),
            // Add more budget details if needed
          ],
        ),
      ),
    );
  }

  void _showEditBudgetDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController(text: budget.categoryName);
    final TextEditingController amountController =
        TextEditingController(text: budget.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: 'Budget Name'),
              ),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(hintText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newAmount = double.tryParse(amountController.text.trim()) ?? budget.amount;
                if (newAmount > 0) {
                  context.read<BudgetCubit>().updateBudget(
                      uid: budget.uid,
                      groupId: budget.groupId,
                      categoryName: budget.categoryName, // Pass the new category name
                      amount: newAmount);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Budget updated successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

}
