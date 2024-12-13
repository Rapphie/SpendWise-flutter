import 'package:cloud_firestore/cloud_firestore.dart';

class GroupRemote {
  final String groupName;
  final String? createdAt;
  final String? ownerId;
  final List<String>? categoryList;
  final List<String>? memberList;

  GroupRemote({
    this.groupName = 'personal',
    this.createdAt,
    this.ownerId,
    this.categoryList,
    this.memberList,
  });

  factory GroupRemote.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return GroupRemote(
      groupName: data?['name'],
      createdAt: data?['createdAt'],
      ownerId: data?['ownerId'],
      categoryList: data?['categoryList'] is Iterable ? List.from(data?['categoryList']) : null,
      memberList: data?['memberList'] is Iterable ? List.from(data?['memberList']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": groupName,
      if (createdAt != null) "createdAt": createdAt,
      if (ownerId != null) "ownerId": ownerId,
      if (categoryList != null) "budget": categoryList,
      if (memberList != null) "memberList": memberList,
    };
  }
}
