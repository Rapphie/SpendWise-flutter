import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:spend_wise/features/auth/presentation/pages/auth_page.dart';
import 'package:spend_wise/features/group/presentation/cubits/group_cubit.dart';
import 'package:spend_wise/features/group/presentation/pages/group_page.dart';
import 'package:spend_wise/features/home/presentation/pages/my_home_page.dart';
import 'package:spend_wise/features/invite/presentation/cubits/invite_cubit.dart';
import 'report.dart';
import 'package:spend_wise/features/invite/presentation/pages/invites_page.dart'; // Add import for InvitesPage

class PoolPage extends StatefulWidget {
  final int selectedIndex;
  const PoolPage({super.key, required this.selectedIndex});

  @override
  State<PoolPage> createState() => _PoolPageState();
}

class _PoolPageState extends State<PoolPage> {
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
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pool'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GroupPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const InvitesPage()),
              );
            },
          ),
          // ...existing actions...
        ],
      ),
      body: SingleChildScrollView(
        // Wrap Column with SingleChildScrollView
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue[900], // dark blue color
                borderRadius: BorderRadius.circular(12.0), // rounded corners
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // adjust spacing
                children: [
                  Text(
                    'Expenses',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800, // Montserrat ExtraBold 800
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
                      fontWeight: FontWeight.w500, // Montserrat Medium 500
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800, // Montserrat ExtraBold 800
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800, // Montserrat ExtraBold 800
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Category',
                ),
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800, // Montserrat ExtraBold 800
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                // Removed IconButton and its surrounding Container
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Amount',
                ),
              ),
            ),
            const SizedBox(height: 20), // Add spacing before the button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the background color to blue
              ),
              onPressed: () {
                // Add your onPressed code here!
              },
              child: const Text(
                'Add Transaction',
                style:
                    TextStyle(color: Color.fromARGB(255, 247, 247, 247)), // Set text color to white
              ),
            ),
            const Divider(), // Add divider above "You"

            // Add divider above cloned "You"
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500, // Montserrat ExtraBold 800
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to the right
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // changed to bold
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0), // Align to the right
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, // changed to bold
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 500.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.green, // changed to green
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Coffee',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Snacks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Juice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 16.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Clothes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 140.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const Divider(), // Add divider above "Kendrick Lmao"
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Kent Baldo',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500, // Montserrat ExtraBold 800
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to the right
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // changed to bold
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0), // Align to the right
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, // changed to bold
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 500.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.green, // changed to green
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Coffee',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Snacks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Juice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 16.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Clothes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 140.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const Divider(), // Add divider above cloned "Kendrick Lmao"
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Christian Plasabas',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500, // Montserrat ExtraBold 800
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to the right
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // changed to bold
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0), // Align to the right
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, // changed to bold
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 500.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.green, // changed to green
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Coffee',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Snacks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Juice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 16.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Clothes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 140.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const Divider(), // Add divider above cloned "Kendrick Lmao"
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Brian Jade Serentas',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500, // Montserrat ExtraBold 800
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, top: 10.0), // Add padding
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align to the right
                  children: [
                    Text(
                      'Recent Transactions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold, // changed to bold
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16.0), // Align to the right
                      child: Text(
                        'Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold, // changed to bold
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Salary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 500.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.green, // changed to green
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Coffee',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Snacks',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 20.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Juice',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 16.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15), // Add spacing between rows
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16.0), // Move to the right
                  child: Text(
                    'Clothes',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0), // Move to the right
                  child: Text(
                    'Php 140.00',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal, // changed to normal
                      fontFamily: 'Montserrat',
                      color: Colors.red, // changed to red
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Add spacing below cloned section
          ],
        ),
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
        currentIndex: widget.selectedIndex,
        onTap: (index) {
          if (index == 0 && widget.selectedIndex != 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()), // Navigate to MyHomePage
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
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: const Center(
        child: Text('Transactions Page Content'),
      ),
    );
  }
}
