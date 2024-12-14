import 'package:cloud_firestore/cloud_firestore.dart';

class AppBudget {
  final String uid;
  final String groupUid;
  final String name;
  final String category;
  final double value;
  final String memberId;
  final Timestamp? createdOn;
  final Timestamp? updatedOn;

  AppBudget({
    required this.uid,
    required this.groupUid,
    required this.name,
    required this.category,
    required this.value,
    required this.memberId,
    this.createdOn,
    this.updatedOn,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'groupUid': groupUid,
      'name': name,
      'category': category,
      'value': value,
      'memberId': memberId,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }

  factory AppBudget.fromJson(Map<String, dynamic> jsonUser) {
    return AppBudget(
      uid: jsonUser['uid'],
      groupUid: jsonUser['groupUid'],
      name: jsonUser['name'],
      category: jsonUser['category'],
      value: jsonUser['value'],
      memberId: jsonUser['memberId'],
      createdOn: jsonUser['createdOn'],
      updatedOn: jsonUser['updatedOn'],
    );
  }
}
