import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/budget/domain/repositories/budget_repository.dart';
import 'package:spend_wise/features/budget/presentation/pages/budget_detail_page.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_states.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_cubit.dart';
import 'package:spend_wise/features/expense/presentation/pages/expense_page.dart';

class BudgetPage extends StatefulWidget {
  final String groupId;

  const BudgetPage({super.key, required this.groupId});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  String? selectedBudgetName; // Replace TextField with Dropdown
  List<String> categoryList = []; // Fetch categories from the selected group
  late BudgetCubit _budgetCubit;

  @override
  void initState() {
    super.initState();
    _budgetCubit = BudgetCubit(budgetRepo: context.read<BudgetRepository>());
    _budgetCubit.loadBudgets(groupId: widget.groupId);
  }

  @override
  void dispose() {
    _budgetCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _budgetCubit,
      child: BlocListener<BudgetCubit, BudgetState>( // Add BlocListener
        listener: (context, state) {
          if (state is BudgetCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is BudgetError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Budgets'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _showCreateBudgetDialog(context);
                  print(widget.groupId);
                },
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  // Implement logout functionality if needed
                },
              ),
              IconButton(
                icon: const Icon(Icons.money),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExpensePage(groupId: widget.groupId),
                    ),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<BudgetCubit, BudgetState>(
            builder: (context, state) {
              if (state is BudgetLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BudgetsLoaded) {
                final budgets = state.budgets;
                if (budgets.isEmpty) {
                  return const Center(child: Text('No budgets found.'));
                }
                return ListView.builder(
                  itemCount: budgets.length,
                  itemBuilder: (context, index) {
                    final budget = budgets[index];
                    return ListTile(
                      title: Text(budget.categoryName),
                      subtitle: Text('Amount: \$${budget.amount.toStringAsFixed(2)}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BudgetDetailPage(budget: budget),
                          ),
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          context
                              .read<BudgetCubit>()
                              .deleteBudget(budgetUid: budget.uid, groupId: budget.groupId);
                        },
                      ),
                    );
                  },
                );
              } else if (state is BudgetError) {
                return Center(child: Text(state.message));
              } else {
                return const Center(child: Text('No budgets found.'));
              }
            },
          ),
        ),
      ),
    );
  }

  void _showCreateBudgetDialog(BuildContext context) {
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create Budget'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  if (state is GroupsLoaded) {
                    final categories = state.groups
                        .firstWhere((group) => group.uid == widget.groupId)
                        .categoryList;
                    if (categories == null || categories.isEmpty) {
                      return const Text('No categories available. Please add categories first.');
                    }
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Budget Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedBudgetName,
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedBudgetName = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a budget category' : null,
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
                print(widget.groupId);
                final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
                if (selectedBudgetName != null && amount > 0) {
                  context.read<BudgetCubit>().createBudget(
                      groupId: widget.groupId, name: selectedBudgetName!, amount: amount);
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
