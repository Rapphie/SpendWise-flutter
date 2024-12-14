import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';

import 'package:spend_wise/features/group/domain/repositories/group_repository.dart';

class GroupRepoImpl implements GroupRepository {
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
        categoryList: [],
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
  Future<List<AppGroup>?> getMembers({required String groupUid}) async {
    try {
      DocumentSnapshot groupDoc = await firebasefirestore.collection('groups').doc(groupUid).get();
      if (groupDoc.exists) {
        List<dynamic> memberIds = groupDoc.get('memberList');
        List<AppGroup> members = [];
        for (var memberId in memberIds) {
          DocumentSnapshot userDoc =
              await firebasefirestore.collection('users').doc(memberId as String).get();
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
  Future<List<String>?> getCategories({required String groupUid}) async {
    try {
      DocumentSnapshot groupDoc =
          await firebasefirestore.collection('groups').doc(groupUid).get();
      if (groupDoc.exists) {
        List<dynamic> categoryList = groupDoc.get('categoryList') ?? [];
        return categoryList.cast<String>();
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to get categories: $e');
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
  Future<void> inviteMember({required String groupUid, required String memberUid}) async {
    try {
      // Check if the user is already a member of the group
      final groupDoc = await firebasefirestore.collection('groups').doc(groupUid).get();
      final groupData = groupDoc.data();
      if (groupData != null && (groupData['members'] as List).contains(memberUid)) {
        throw Exception('User is already a member of the group');
      }

      await firebasefirestore.collection('groupInvites').add({
        'groupUid': groupUid,
        'memberUid': memberUid,
        'invitedBy': currentUser!.uid,
        'status': 'pending',
        'createdOn': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to invite member: $e');
    }
  }

  @override
  Future<void> acceptInvite({required String groupUid, required String memberUid}) async {
    try {
      // Add member to the group's memberList
      await firebasefirestore.collection('groups').doc(groupUid).update({
        'memberList': FieldValue.arrayUnion([memberUid]),
        'updatedOn': Timestamp.now(),
      });

      // Remove the invite
      QuerySnapshot invites = await firebasefirestore
          .collection('groupInvites')
          .where('groupUid', isEqualTo: groupUid)
          .where('memberUid', isEqualTo: memberUid)
          .get();

      for (var doc in invites.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to accept invite: $e');
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
}
