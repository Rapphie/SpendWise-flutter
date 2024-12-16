
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expense/domain/repositories/expense_repository.dart';
import 'package:spend_wise/features/expense/presentation/cubits/expense_cubit.dart';
import 'package:spend_wise/features/expense/presentation/cubits/expense_states.dart';
import 'package:spend_wise/features/expense/presentation/pages/expense_detail_page.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';

class ExpensePage extends StatefulWidget {
  final String groupId;

  const ExpensePage({super.key, required this.groupId});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  late ExpenseCubit _expenseCubit;

  @override
  void initState() {
    super.initState();
    _expenseCubit = ExpenseCubit(expenseRepo: context.read<ExpenseRepository>());
    _expenseCubit.loadExpenses(groupId: widget.groupId);
  }

  @override
  void dispose() {
    _expenseCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _expenseCubit,
      child: BlocListener<ExpenseCubit, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseCreated || state is ExpenseUpdated || state is ExpenseDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text((state as dynamic).message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Expenses'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateExpenseDialog(context);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Implement logout functionality if needed
                },
              ),
            ],
          ),
          body: BlocBuilder<ExpenseCubit, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ExpensesLoaded) {
                final expenses = state.expenses;
                if (expenses.isEmpty) {
                  return const Center(child: Text('No expenses found.'));
                }
                return ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    return ListTile(
                      title: Text(expense.categoryName),
                      subtitle: Text('Amount: \$${expense.amount.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExpenseDetailPage(expense: expense),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context.read<ExpenseCubit>().deleteExpense(expenseUid: expense.uid, groupId: widget.groupId);
                        },
                      ),
                    );
                  },
                );
              } else if (state is ExpenseError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No expenses found.'));
              }
            },
          ),
        ),
      ),
    );
  }

  void _showCreateExpenseDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();
    String? selectedCategory;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Expense'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Replace with Dropdown for categories
              // Assuming categories are available from GroupCubit
              BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  if (state is GroupsLoaded) {
                    final categories = state.groups
                        .firstWhere((group) => group.uid == widget.groupId)
                        .categoryList;
                    if (categories!.isEmpty) {
                      return const Text('No categories available. Please add categories first.');
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Expense Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select an expense category' : null,
                    );
                  } else if (state is GroupLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return const Text('Failed to load categories.');
                  }
                },
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
                final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
                if (selectedCategory != null && amount > 0) {
                  context.read<ExpenseCubit>().createExpense(
                      groupId: widget.groupId, categoryName: selectedCategory!, amount: amount);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category and enter a valid amount.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
}