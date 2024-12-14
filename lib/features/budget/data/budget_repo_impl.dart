import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/budget/domain/entities/app_budget.dart';
import 'package:spend_wise/features/budget/domain/repositories/budget_repository.dart';


class BudgetRepoImpl implements BudgetRepository {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  @override
  Future<AppBudget?> createBudget({required String name, required String groupUid}) async {
    try {
      // Fetch the group's categoryList
      DocumentSnapshot groupDoc =
          await firebasefirestore.collection('groups').doc(groupUid).get();
      if (groupDoc.exists) {
        List<dynamic> categoryList = groupDoc.get('categoryList') ?? [];

        // Create a budget for a category
        for (var category in categoryList) {
          String budgetId = firebasefirestore.collection('budgets').doc().id;

          AppBudget budget = AppBudget(
            uid: budgetId,
            groupUid: groupUid,
            name: name, // Using the provided name
            category: category as String,
            value: 0.0, // Set an initial value or modify as needed
            memberId: currentUser!.uid,
            createdOn: Timestamp.now(),
            updatedOn: Timestamp.now(),
          );

          await firebasefirestore.collection('budgets').doc(budgetId).set(budget.toJson());
        }
        return null; // Since multiple budgets are created
      } else {
        throw Exception('Group not found');
      }
    } catch (e) {
      throw Exception('Failed to create budgets: $e');
    }
  }

  @override
  Future<AppBudget?> updateBudget({required String uid, required String groupUid, String? name, double? value}) async {
    try {
      // Fetch the budget document
      QuerySnapshot budgetSnapshot = await firebasefirestore
          .collection('budgets')
          .where('groupUid', isEqualTo: groupUid)
          .where('uid', isEqualTo: uid)
          .get();

      if (budgetSnapshot.docs.isNotEmpty) {
        DocumentSnapshot budgetDoc = budgetSnapshot.docs.first;
        AppBudget budget = AppBudget.fromJson(budgetDoc.data() as Map<String, dynamic>);

        // Update the budget
        budget = AppBudget(
          uid: budget.uid,
          groupUid: budget.groupUid,
          name: name ?? budget.name,
          category: budget.category,
          value: value ?? budget.value,
          memberId: budget.memberId,
          createdOn: budget.createdOn,
          updatedOn: Timestamp.now(),
        );

        await firebasefirestore.collection('budgets').doc(budget.uid).update(budget.toJson());
        return budget;
      } else {
        throw Exception('Budget not found');
      }
    } catch (e) {
      throw Exception('Failed to update budget: $e');
    }
  }

  @override
  Future<void> getGroupBudget({required String groupUid, required String memberUid}) async {
    try {
      QuerySnapshot budgetSnapshot = await firebasefirestore
          .collection('budgets')
          .where('groupUid', isEqualTo: groupUid)
          .where('memberId', isEqualTo: memberUid)
          .get();

      if (budgetSnapshot.docs.isNotEmpty) {
        // Process the budgets as needed
        for (var doc in budgetSnapshot.docs) {
          AppBudget budget = AppBudget.fromJson(doc.data() as Map<String, dynamic>);
          // Do something with the budget
        }
      } else {
        throw Exception('No budgets found for the group and member');
      }
    } catch (e) {
      throw Exception('Failed to get group budget: $e');
    }
  }

  @override
  Future<void> deleteBudget({required String groupUid}) async {
    try {
      QuerySnapshot budgetSnapshot = await firebasefirestore
          .collection('budgets')
          .where('groupUid', isEqualTo: groupUid)
          .get();

      for (var doc in budgetSnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete budget: $e');
    }
  }

  @override
  Future<void> createBudgetsForGroupCategories({
    required String groupUid,
    required double value,
  }) async {
    try {
      // Fetch the group's categoryList
      DocumentSnapshot groupDoc =
          await firebasefirestore.collection('groups').doc(groupUid).get();
      if (groupDoc.exists) {
        List<dynamic> categoryList = groupDoc.get('categoryList') ?? [];

        // Create a budget for each category
        for (var category in categoryList) {
          String budgetId = firebasefirestore.collection('budgets').doc().id;

          AppBudget budget = AppBudget(
            uid: budgetId,
            groupUid: groupUid,
            name: category as String, // Using category as the name
            category: category,
            value: value,
            memberId: currentUser!.uid,
            createdOn: Timestamp.now(),
            updatedOn: Timestamp.now(),
          );

          await firebasefirestore.collection('budgets').doc(budgetId).set(budget.toJson());
        }
      } else {
        throw Exception('Group not found');
      }
    } catch (e) {
      throw Exception('Failed to create budgets: $e');
    }
  }
}
