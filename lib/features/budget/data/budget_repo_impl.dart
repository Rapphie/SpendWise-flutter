import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';
import 'package:spend_wise/features/budget/domain/repositories/budget_repository.dart';

class BudgetRepoImpl implements BudgetRepository {
  late AppUser currentUser;
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  @override
  Future<AppBudget?> createBudget({required String categoryName, required String groupId, required double amount}) async {
    try {
      // Fetch the group's categoryList
      DocumentSnapshot groupDoc =
          await firebasefirestore.collection('groups').doc(groupId).get();
      if (groupDoc.exists) {
        List<dynamic> categoryList = groupDoc.get('categoryList') ?? [];

        // Check if the category exists in the categoryList
        if (categoryList.contains(categoryName)) {
          String budgetId = firebasefirestore.collection('budgets').doc().id;
          print(categoryName);
          AppBudget budget = AppBudget(
            uid: budgetId,
            groupId: groupId,
            categoryName: categoryName, // Using the provided name
            amount: amount, // Set the provided amount
            createdBy: currentUser.name,
            updatedBy: currentUser.name,
            createdOn: Timestamp.now(),
            updatedOn: Timestamp.now(),
          );

          await firebasefirestore.collection('budgets').doc(budgetId).set(budget.toJson());
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
  Future<AppBudget?> updateBudget({required String uid, required String groupId, String? categoryName, double? amount}) async {
    try {
      DocumentReference budgetRef = firebasefirestore.collection('budgets').doc(uid);
      DocumentSnapshot budgetDoc = await budgetRef.get();

      if (budgetDoc.exists) {
        Map<String, dynamic> updatedData = {};
        updatedData['categoryName'] = categoryName ?? budgetDoc.get('categoryName');
        updatedData['amount'] = amount ?? budgetDoc.get('amount');
        updatedData['updatedBy'] = currentUser.name;
        updatedData['updatedOn'] = Timestamp.now();

        await budgetRef.update(updatedData);

        DocumentSnapshot updatedDoc = await budgetRef.get();
        return AppBudget.fromJson(updatedDoc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Budget not found');
      }
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  @override
  Future<List<AppBudget>> getGroupBudgets({required String groupId}) async {
    try {
      QuerySnapshot budgetSnapshot = await firebasefirestore
          .collection('budgets')
          .where('groupId', isEqualTo: groupId)
          .get();

      if (budgetSnapshot.docs.isNotEmpty) {
        return budgetSnapshot.docs.map((doc) => AppBudget.fromJson(doc.data() as Map<String, dynamic>)).toList();
      } else {
        throw Exception('No budgets found for the group and member');
      }
    } catch (e) {
      throw Exception('Failed to get group budgets: $e');
    }
  }

  @override
  Future<void> deleteBudget({required String budgetUid}) async {
    try {
      await firebasefirestore.collection('budgets').doc(budgetUid).delete();
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }
}
