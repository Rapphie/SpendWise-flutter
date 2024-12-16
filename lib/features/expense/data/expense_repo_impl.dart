import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/expense/domain/entities/app_expense.dart';
import 'package:spend_wise/features/expense/domain/repositories/expense_repository.dart';

class ExpenseRepoImpl implements ExpenseRepository {
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AppUser? currentUser;

  ExpenseRepoImpl() {
    _initializeCurrentUser(); // Initialize currentUser in constructor
  }

  Future<void> _initializeCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      // Fetch user details from Firestore or another source
      DocumentSnapshot userDoc = await firebasefirestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        currentUser = AppUser.fromJson(userDoc.data() as Map<String, dynamic>);
      } else {
        currentUser = AppUser(
            uid: user.uid, name: user.displayName ?? '', email: user.email ?? '', groups: []);
      }
    } else {
      throw Exception('No authenticated user found');
    }
  }

  @override
  Future<AppExpense?> createExpense(
      {required String categoryName, required String groupId, required double amount}) async {
    try {
      // Ensure currentUser is initialized
      if (currentUser == null) {
        await _initializeCurrentUser();
      }

      // Fetch the group's categoryList
      DocumentSnapshot groupDoc = await firebasefirestore.collection('groups').doc(groupId).get();
      if (groupDoc.exists) {
        List<dynamic> categoryList = groupDoc.get('categoryList') ?? [];

        // Check if the category exists in the categoryList
        if (categoryList.contains(categoryName)) {
          String budgetId = firebasefirestore.collection('budgets').doc().id;
          print(categoryName);
          AppExpense budget = AppExpense(
            uid: budgetId,
            groupId: groupId,
            categoryName: categoryName,
            amount: amount,
            userId: currentUser!.uid,
            createdBy: currentUser!.name,
            updatedBy: currentUser!.name,
            createdOn: Timestamp.now(),
            updatedOn: Timestamp.now(),
          );

          await firebasefirestore.collection('expenses').doc(budgetId).set(budget.toJson());
          return budget;
        } else {
          throw Exception('Category not found in the group');
        }
      } else {
        throw Exception('Group not found');
      }
    } catch (e) {
      throw Exception('Failed to create budget for category: $e');
    }
  }

  @override
  Future<void> deleteExpense({required String expenseUid}) async {
    try {
      await firebasefirestore.collection('expenses').doc(expenseUid).delete();
    } catch (e) {
      throw Exception('Failed to delete expense: $e');
    }
  }

  @override
  Future<List<AppExpense>> getGroupExpenses({required String groupId}) async {
    try {
      QuerySnapshot expenseSnapshot =
          await firebasefirestore.collection('expenses').where('groupId', isEqualTo: groupId).get();

      List<AppExpense> expenses = expenseSnapshot.docs.map((doc) {
        return AppExpense.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return expenses;
    } catch (e) {
      throw Exception('Failed to load group expenses: $e');
    }
  }

  @override
  Future<AppExpense?> updateExpense(
      {required String uid, required String groupId, String? categoryName, double? amount}) async {
    try {
      // Ensure currentUser is initialized
      if (currentUser == null) {
        await _initializeCurrentUser();
      }

      DocumentReference expenseRef = firebasefirestore.collection('expenses').doc(uid);
      DocumentSnapshot expenseDoc = await expenseRef.get();

      if (expenseDoc.exists) {
        Map<String, dynamic> updatedData = {};
        updatedData['categoryName'] = categoryName ?? expenseDoc.get('categoryName');
        updatedData['userId'] = currentUser!.uid;
        updatedData['amount'] = amount ?? expenseDoc.get('amount');
        updatedData['updatedOn'] = Timestamp.now();

        await expenseRef.update(updatedData);

        DocumentSnapshot updatedDoc = await expenseRef.get();
        return AppExpense.fromJson(updatedDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Expense not found');
      }
    } catch (e) {
      throw Exception('Failed to update expense: $e');
    }
  }
}
