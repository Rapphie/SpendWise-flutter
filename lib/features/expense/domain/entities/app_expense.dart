import 'package:cloud_firestore/cloud_firestore.dart';

class AppExpense {
  final String uid;
  final String groupId;
  final String categoryName;
  final double amount;
  final String userId;
  final String createdBy;
  final String updatedBy;
  final Timestamp createdOn;
  final Timestamp updatedOn;

  AppExpense({
    required this.uid,
    required this.groupId,
    required this.categoryName,
    required this.amount,
    required this.userId,
    required this.createdBy,
    required this.updatedBy,
    required this.createdOn,
    required this.updatedOn,
  });

  factory AppExpense.fromJson(Map<String, dynamic> json) {
    return AppExpense(
      uid: json['uid'],
      groupId: json['groupId'],
      categoryName: json['categoryName'],
      amount: json['amount'].toDouble(),
      userId: json['userId'],
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
      'userId': userId,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }
}
