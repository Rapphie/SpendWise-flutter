import 'package:cloud_firestore/cloud_firestore.dart';

class AppGroup {
  final String uid;
  final String name;
  final String ownerId;
  final List<String>? categoryList;
  final List<String> memberList;
  final Timestamp? createdOn;
  final Timestamp? updatedOn;

  AppGroup({
    required this.uid,
    required this.name,
    required this.ownerId,
    this.categoryList,
    required this.memberList,
    this.createdOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'ownerId': ownerId,
      'categoryList': categoryList,
      'memberList': memberList,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }

  factory AppGroup.fromJson(Map<String, dynamic> jsonUser) {
    return AppGroup(
      uid: jsonUser['uid'],
      name: jsonUser['name'],
      ownerId: jsonUser['ownerId'],
      categoryList:
          jsonUser['categoryList'] != null ? List<String>.from(jsonUser['categoryList']) : null,
      memberList: List<String>.from(jsonUser['memberList']),
      createdOn: jsonUser['createdOn'],
      updatedOn: jsonUser['updatedOn'],
    );
  }
}
