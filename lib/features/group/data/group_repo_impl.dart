import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';

import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';

class GroupRepoImpl implements GroupRepository {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  String get currentUserUid => currentUser!.uid;

  @override
  Future<AppGroup> createGroup({required String name}) async {
    try {
      final group = AppGroup(
          uid: firebasefirestore.collection('groups').doc().id,
          name: name,
          ownerId: currentUserUid,
          memberList: [currentUserUid],
          categoryList: [],
          createdOn: Timestamp.now(),
          updatedOn: Timestamp.now());
      await firebasefirestore.collection('groups').doc(group.uid).set(group.toJson());
      return group;
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  @override
  Future<void> createCategory({required String groupUid, required String categoryName}) async {
    try {
      final groupRef = firebasefirestore.collection('groups').doc(groupUid);
      await groupRef.update({
        'categoryList': FieldValue.arrayUnion([categoryName]),
      });
    } catch (e) {
      throw Exception('Failed to create category: $e');
    }
  }

  @override
  Future<AppGroup> updateGroup({required String groupUid, required String newName}) async {
    try {
      DocumentReference groupRef = firebasefirestore.collection('groups').doc(groupUid);
      await groupRef.update({'name': newName});
      DocumentSnapshot updatedGroupDoc = await groupRef.get();
      return AppGroup.fromJson(updatedGroupDoc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to update group: $e');
    }
  }

  @override
  Future<void> deleteGroup({required String groupUid}) async {
    try {
      await firebasefirestore.collection('groups').doc(groupUid).delete();
    } catch (e) {
      throw Exception('Failed to delete group: $e');
    }
  }

  @override
  Future<List<AppGroup>> getUserGroups() async {
    try {
      QuerySnapshot groupSnapshot = await firebasefirestore
          .collection('groups')
          .where('memberList', arrayContains: currentUser!.uid)
          .get();

      List<AppGroup> groups = groupSnapshot.docs.map((doc) {
        return AppGroup.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      return groups;
    } catch (e) {
      throw Exception('Failed to load user groups: $e');
    }
  }

  @override
  Future<List<AppUser>> getMembers({required String groupUid}) async {
    try {
      DocumentSnapshot groupDoc = await firebasefirestore.collection('groups').doc(groupUid).get();
      if (groupDoc.exists) {
        List<dynamic> memberIds = groupDoc.get('memberList') ?? [];
        List<AppUser> members = [];
        for (var memberId in memberIds) {
          DocumentSnapshot userDoc =
              await firebasefirestore.collection('users').doc(memberId as String).get();
          if (userDoc.exists) {
            members.add(AppUser.fromJson(userDoc.data() as Map<String, dynamic>));
          } else {
            print('User document not found for ID: $memberId');
          }
        }
        return members;
      } else {
        print('Group document does not exist for ID: $groupUid');
        return [];
      }
    } catch (e) {
      print('Failed to get members: $e');
      throw Exception('Failed to get members: $e');
    }
  }

  @override
  Future<List<String>> getCategories({required String groupUid}) async {
    try {
      DocumentSnapshot groupDoc = await firebasefirestore.collection('groups').doc(groupUid).get();
      if (groupDoc.exists) {
        List<dynamic> categoryList = groupDoc.get('categoryList') ?? [];
        return categoryList.cast<String>();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Failed to get categoryList: $e');
    }
  }
}
