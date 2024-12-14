import 'package:cloud_firestore/cloud_firestore.dart';

class GroupInvite {
  final String id;
  final String groupUid;
  final String groupName;
  final String senderUid;
  final String receiverUid;
  final String status;
  final Timestamp sentOn;

  GroupInvite({
    required this.id,
    required this.groupUid,
    required this.groupName,
    required this.senderUid,
    required this.receiverUid,
    required this.status,
    required this.sentOn,
  });

  factory GroupInvite.fromJson(Map<String, dynamic> json, String id) {
    return GroupInvite(
      id: id,
      groupUid: json['groupUid'],
      groupName: json['groupName'],
      senderUid: json['senderUid'],
      receiverUid: json['receiverUid'],
      status: json['status'],
      sentOn: json['sentOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupUid': groupUid,
      'groupName': groupName,
      'senderUid': senderUid,
      'receiverUid': receiverUid,
      'status': status,
      'sentOn': Timestamp.now(),
    };
  }
}