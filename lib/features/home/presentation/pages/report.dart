import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/home/presentation/pages/my_home_page.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_cubit.dart';
import 'pool.dart'; // Ensure pool.dart is imported
import 'package:pie_chart/pie_chart.dart'; // Add pie_chart package

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  get context => null;
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
    // Navigator.pop(context);
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => const AuthPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 18), // Add top padding
            child: Center(
              child: Text(
                'Spending Report for the Month',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Personal',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: PieChart(
              dataMap: const {
                "Food": 30,
                "Transport": 20,
                "Entertainment": 25,
                "Others": 25,
              },
              chartType: ChartType.disc,
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: MediaQuery.of(context).size.width / 2.2, // Increase size
              colorList: const [Colors.blue, Colors.red, Colors.green, Colors.yellow],
              initialAngleInDegree: 0,
              ringStrokeWidth: 32,
              legendOptions: const LegendOptions(
                showLegends: false,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
              ),
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          const Text(
            'Pool',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: PieChart(
              dataMap: const {
                "Rent": 40,
                "Utilities": 30,
                "Savings": 20,
                "Misc": 10,
              },
              chartType: ChartType.disc,
              animationDuration: const Duration(milliseconds: 800),
              chartRadius: MediaQuery.of(context).size.width / 2.2, // Increase size
              colorList: const [Colors.purple, Colors.orange, Colors.pink, Colors.cyan],
              initialAngleInDegree: 0,
              ringStrokeWidth: 32,
              legendOptions: const LegendOptions(
                showLegends: false,
              ),
              chartValuesOptions: const ChartValuesOptions(
                showChartValueBackground: false,
                showChartValues: false,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt), // changed to Transactions icon
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group), // changed to MultiUser icon
            label: 'Pool',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart), // changed to BarGraph icon
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout), // changed to logout icon
            label: 'Logout',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2, // Set the current index to Report
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PoolPage(selectedIndex: 1)),
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
          // Add navigation logic for other items if needed
        },
      ),
    );
  }
}
