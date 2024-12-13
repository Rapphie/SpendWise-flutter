import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';

import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';

class FirebaseGroupRepository implements GroupRepository {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  @override
  Future<AppGroup?> createGroup({required String name}) async {
    try {
      String groupId = firebasefirestore.collection('groups').doc().id;

      AppGroup group = AppGroup(
        uid: groupId,
        name: name,
        ownerId: currentUser!.uid,
        memberList: [currentUser!.uid],
        createdOn: Timestamp.now(),
        updatedOn: Timestamp.now(),
      );

      await firebasefirestore.collection('groups').doc(groupId).set(group.toJson());
      return group;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<List<AppGroup>?> getMembers({required String groupuid}) async {
    try {
      DocumentSnapshot groupDoc = await firebasefirestore.collection('groups').doc(groupuid).get();
      if (groupDoc.exists) {
        List<dynamic> memberIds = groupDoc.get('memberList');
        List<AppGroup> members = [];
        for (var memberId in memberIds) {
          DocumentSnapshot userDoc = await firebasefirestore.collection('users').doc(memberId as String).get();
          if (userDoc.exists) {
            members.add(AppGroup.fromJson(userDoc.data() as Map<String, dynamic>));
          }
        }
        return members;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get members: $e');
    }
  }

  @override
  Future<List<String>?> getCategories({required String groupuid}) async {
    try {
      DocumentSnapshot groupDoc = await firebasefirestore.collection('groups').doc(groupuid).get();
      if (groupDoc.exists) {
        List<dynamic> categories = groupDoc.get('categories');
        return categories.cast<String>();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get categories: $e');
    }
  }

  @override
  Future<void> deleteGroup({required String groupuid}) async {
    try {
      await firebasefirestore.collection('groups').doc(groupuid).delete();
    } catch (e) {
      throw Exception('Failed to delete group: $e');
    }
  }
}
