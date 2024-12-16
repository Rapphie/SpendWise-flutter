import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';
import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';
import 'package:spend_wise/features/budget/presentation/cubits/budget_cubit.dart';
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';
import 'package:spend_wise/features/expense/presentation/cubits/expense_cubit.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_states.dart';
import 'package:spend_wise/features/group/presentation/pages/categories_page.dart';
import 'package:spend_wise/features/home/presentation/pages/pool.dart';
import 'package:spend_wise/features/home/presentation/pages/report.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_cubit.dart';
import 'package:spend_wise/features/home/data/home_repo_impl.dart';
import 'package:spend_wise/utils/dateformatter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  initState() {
    super.initState();
  }

  String? selectedCategory;
  TextEditingController amountController = TextEditingController();
  final HomeRepoImpl homeRepository = HomeRepoImpl();
  String? userUid;

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
    final authState = context.watch<AuthCubit>().state;
    String userName = 'Guest';
    if (authState is Authenticated) {
      userName = authState.user.name;
      userUid = authState.user.uid;
    }
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<GroupCubit, GroupState>(
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
                  }
                },
                underline: const SizedBox(), // Remove underline if desired
              );
            } else if (state is GroupLoading) {
              return const CircularProgressIndicator();
            } else {
              return const SizedBox();
            }
          },
        ),
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        // Added to prevent overflow
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg7.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Welcome back,\n',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: userName,
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              BlocBuilder<GroupCubit, GroupState>(
                builder: (context, state) {
                  final groupCubit = context.read<GroupCubit>();
                  if (state is GroupsLoaded) {
                    return FutureBuilder<List<String>>(
                      future: context
                          .read<GroupCubit>()
                          .groupRepo
                          .getCategories(groupUid: groupCubit.selectedGroup!.uid)
                          .then((value) => value ?? []),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(child: Text('No categories found.'));
                        } else {
                          final categoryList = snapshot.data!;
                          return DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Select Category',
                              border: OutlineInputBorder(),
                            ),
                            value: selectedCategory,
                            items: categoryList.map((String category) {
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
                            validator: (value) => value == null ? 'Please select a category' : null,
                          );
                        }
                      },
                    );
                  } else {
                    return const Center(child: Text('Loading groups...'));
                  }
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Amount',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showAddTransactionDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text(
                    'Add Transaction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Expense',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '|',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Php 123,456.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              // Add Recent Transactions Table
              FutureBuilder<List<dynamic>>(
                future: homeRepository.recentTransactions(userUid!),
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
                      shrinkWrap: true,
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final transaction = transactions[index];
                        if (transaction is AppBudget) {
                          return ListTile(
                            title: Text(transaction.categoryName,
                                style: const TextStyle(fontSize: 18)),
                            subtitle: Text(fromTimestamp(transaction.createdOn),
                                style: const TextStyle(fontSize: 14)),
                            trailing: Text(
                              'P${transaction.amount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 20, color: Colors.green),
                            ),
                          );
                        } else if (transaction is AppExpense) {
                          return ListTile(
                            title: Text(transaction.categoryName,
                                style: const TextStyle(fontSize: 18)),
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Pool',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            // Do nothing
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PoolPage(selectedIndex: 1)),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ReportPage()),
            );
          } else if (index == 3) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      logout();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Transaction'),
          content: const Text('Select the type of transaction:'),
          actions: [
            TextButton(
              onPressed: () {
                final groupCubit = context.read<GroupCubit>();
                final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
                if (selectedCategory != null && amount > 0) {
                  context.read<BudgetCubit>().createBudget(
                        groupId: groupCubit.selectedGroup!.uid,
                        name: selectedCategory!,
                        amount: amount,
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction added successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category and enter a valid amount.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
                setState(() {
                  homeRepository.recentTransactions(userUid!);
                });
              },
              child: const Text('Budget'),
            ),
            TextButton(
              onPressed: () {
                final groupCubit = context.read<GroupCubit>();
                final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
                if (selectedCategory != null && amount > 0) {
                  context.read<ExpenseCubit>().createExpense(
                        groupId: groupCubit.selectedGroup!.uid,
                        categoryName: selectedCategory!,
                        amount: amount,
                      );
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction added successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a category and enter a valid amount.'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              child: const Text('Expense'),
            ),
          ],
        );
      },
    );
  }
}
