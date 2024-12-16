
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';
import 'package:spend_wise/features/expense/presentation/cubits/expense_cubit.dart';
import 'package:spend_wise/features/expense/presentation/cubits/expense_states.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';

class ExpenseDetailPage extends StatefulWidget {
  final AppExpense expense;

  const ExpenseDetailPage({super.key, required this.expense});

  @override
  State<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends State<ExpenseDetailPage> {
  late TextEditingController _amountController;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: widget.expense.amount.toString());
    _selectedCategory = widget.expense.categoryName;
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ExpenseCubit, ExpenseState>(
      listener: (context, state) {
        if (state is ExpenseUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
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
          title: const Text('Expense Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Category Dropdown
              BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  if (state is GroupsLoaded) {
                    final categories = state.groups
                        .firstWhere((group) => group.uid == widget.expense.groupId)
                        .categoryList;
                    if (categories!.isEmpty) {
                      return const Text('No categories available.');
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Expense Category',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedCategory,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedCategory = newValue;
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
              const SizedBox(height: 16),
              // Amount TextField
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
                  if (_selectedCategory != null && amount > 0) {
                    context.read<ExpenseCubit>().updateExpense(
                        uid: widget.expense.uid,
                        groupId: widget.expense.groupId,
                        categoryName: _selectedCategory!,
                        amount: amount);
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
                child: const Text('Update Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}