import 'package:cloud_firestore/cloud_firestore.dart';

class AppBudget {
  final String uid;
  final String groupId;
  final String categoryName;
  final double amount;
  final String createdBy;
  final String updatedBy;
  final Timestamp createdOn;
  final Timestamp updatedOn;

  AppBudget({
    required this.uid,
    required this.groupId,
    required this.categoryName,
    required this.amount,
    required this.createdBy,
    required this.updatedBy,
    required this.createdOn,
    required this.updatedOn,
  });

  factory AppBudget.fromJson(Map<String, dynamic> json) {
    return AppBudget(
      uid: json['uid'],
      groupId: json['groupId'],
      categoryName: json['categoryName'],
      amount: json['amount'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      createdOn: json['createdOn'],
      updatedOn: json['updatedOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'groupId': groupId,
      'categoryName': categoryName,
      'amount': amount,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
