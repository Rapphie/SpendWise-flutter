import 'package:cloud_firestore/cloud_firestore.dart';

class GroupInvite {
  final String id;
  final String groupUid;
  final String groupName;
  final String senderName;
  final String receiverUid;
  final String status;
  final Timestamp sentOn;

  GroupInvite({
    required this.id,
    required this.groupUid,
    required this.groupName,
    required this.senderName,
    required this.receiverUid,
    required this.status,
    required this.sentOn,
  });

  factory GroupInvite.fromJson(Map<String, dynamic> json, String id) {
    return GroupInvite(
      id: id,
      groupUid: json['groupUid'],
      groupName: json['groupName'],
      senderName: json['senderName'],
      receiverUid: json['receiverUid'],
      status: json['status'],
      sentOn: json['sentOn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupUid': groupUid,
      'groupName': groupName,
      'senderName': senderName,
      'receiverUid': receiverUid,
      'status': status,
      'sentOn': Timestamp.now(),
    };
  }
}
