import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/group/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/group/presentation/pages/group_page.dart';
import 'package:spend_wise/features/budget/domain/repositories/budget_repository.dart';
import 'package:spend_wise/features/budget/data/budget_repo_impl.dart';
import 'package:spend_wise/features/budget/presentation/pages/budget_detail_page.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_states.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_cubit.dart';

class BudgetPage extends StatefulWidget {
  final String groupId;

  const BudgetPage({super.key, required this.groupId});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late AppUser _currentUser;
  String? selectedBudgetName; // Replace TextField with Dropdown
  List<String> categoryList = []; // Fetch categories from the selected group

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final groupState = context.read<GroupCubit>().state;
    if (groupState is GroupsLoaded && groupState.selectedGroup != null) {
      setState(() {
        categoryList = groupState.selectedGroup!.categoryList!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BudgetCubit(budgetRepo: context.read<BudgetRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Budgets'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showCreateBudgetDialog(context);
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
                  if (state is GroupsLoaded && state.selectedGroup != null) {
                    return DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Select Budget Category',
                        border: OutlineInputBorder(),
                      ),
                      value: selectedBudgetName,
                      items: state.selectedGroup!.categoryList!.map((String category) {
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
                    return const SizedBox();
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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() {
    context.read<AuthCubit>().logout();
    context.read<GroupCubit>().clearGroups();
    context.read<GroupInviteCubit>().clearInvites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully logged out'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              logout();
            },
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const GroupPage()),
            );
          },
          child: const Text('Go to Group Page'),
        ),
      ),
    );
  }
}
