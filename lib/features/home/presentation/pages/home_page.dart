import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_states.dart';
import 'package:spend_wise/features/expense/presentation/cubits/expense_states.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/group/presentation/pages/categories_page.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/group/presentation/pages/group_page.dart'; // Add this import
import 'package:spend_wise/features/expense/presentation/cubits/expense_cubit.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  void logout() {
    context.read<AuthCubit>().logout();
    context.read<GroupCubit>().clearGroups();
    context.read<GroupCubit>().clearMembers();
    context.read<GroupInviteCubit>().clearInvites();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully logged out'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the current auth state
    final authState = context.watch<AuthCubit>().state;
    String userName = 'Guest';
    if (authState is Authenticated) {
      userName = authState.user.name;
    }

    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                if (state is GroupsLoaded) {
                  return DropdownButton<AppGroup>(
                    value: state.selectedGroup,
                    items: state.groups.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(group.name),
                      );
                    }).toList(),
                    onChanged: (AppGroup? newGroup) {
                      if (newGroup != null) {
                        context.read<GroupCubit>().setSelectedGroup(newGroup);
                      } else {
                        print('No group selected');
                      }
                    },
                  );
                } else if (state is GroupLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return const SizedBox();
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GroupPage()),
                );
              },
              child: const Text('Go to Group Page'),
            ),
            ElevatedButton(
              onPressed: () {
                final groupCubit = context.read<GroupCubit>();
                if (groupCubit.selectedGroup != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoriesPage(groupId: groupCubit.selectedGroup!.uid),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No group selected!'),
                    backgroundColor: Colors.redAccent,
                  ));
                }
              },
              child: const Text('Categories'),
            ),
            Text('Welcome, $userName'),

            // Latest Expenses Table
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Latest 10 Expenses',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<ExpenseCubit, ExpenseState>(
                    builder: (context, expenseState) {
                      if (expenseState is ExpensesLoaded) {
                        final latestExpenses = expenseState.expenses
                            .where((expense) =>
                                expense.groupId == context.read<GroupCubit>().selectedGroup?.uid)
                            .take(10)
                            .toList();
                        return DataTable(
                          columns: const [
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Date')),
                          ],
                          rows: latestExpenses.map((expense) {
                            return DataRow(cells: [
                              DataCell(Text(expense.categoryName)),
                              DataCell(Text('\$${expense.amount.toStringAsFixed(2)}')),
                              DataCell(Text(expense.createdOn.toDate().toString())),
                            ]);
                          }).toList(),
                        );
                      } else if (expenseState is ExpenseLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text('No expenses available.');
                      }
                    },
                  ),
                ],
              ),
            ),

            // Latest Budgets Table
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Latest Budgets',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<BudgetCubit, BudgetState>(
                    builder: (context, budgetState) {
                      if (budgetState is BudgetsLoaded) {
                        final latestBudgets = budgetState.budgets
                            .where((budget) =>
                                budget.groupId == context.read<GroupCubit>().selectedGroup?.uid)
                            .take(10)
                            .toList();
                        return DataTable(
                          columns: const [
                            DataColumn(label: Text('Category')),
                            DataColumn(label: Text('Amount')),
                            DataColumn(label: Text('Created On')),
                          ],
                          rows: latestBudgets.map((budget) {
                            return DataRow(cells: [
                              DataCell(Text(budget.categoryName)),
                              DataCell(Text('\$${budget.amount.toStringAsFixed(2)}')),
                              DataCell(Text(budget.createdOn.toDate().toString())),
                            ]);
                          }).toList(),
                        );
                      } else if (budgetState is BudgetLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text('No budgets available.');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
