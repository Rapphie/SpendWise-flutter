import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/group/domain/entities/group_invite.dart';
import 'package:spend_wise/features/group/domain/repositories/invite_repository.dart';

class InviteRepoImpl implements InviteRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  Future<String> _getCurrentUserName() async {
    DocumentSnapshot userDoc = await firestore.collection('users').doc(currentUserUid).get();
    return userDoc.get('name');
  }

  @override
  Future<void> sendInvite({required String groupUid, required String userEmail}) async {
    String inviteId = firestore.collection('groups').doc().id;
    DocumentSnapshot groupRef = await firestore.collection('groups').doc(groupUid).get();

    String memberUid =
        (await firestore.collection('users').where('email', isEqualTo: userEmail).get())
            .docs
            .first
            .id;

    QuerySnapshot existingInvite = await firestore
        .collection('invites')
        .where('groupUid', isEqualTo: groupUid)
        .where('receiverUid', isEqualTo: memberUid)
        .get();

    if (existingInvite.docs.isNotEmpty) {
      throw Exception('Invite already sent to this user.');
    } else if (memberUid.isEmpty) {
      throw Exception('User not found');
    } else {
      String groupName = groupRef.get('name');
      String senderName = await _getCurrentUserName();
      final invite = GroupInvite(
          id: inviteId,
          groupUid: groupUid,
          groupName: groupName,
          senderName: senderName,
          receiverUid: memberUid,
          status: 'pending',
          sentOn: Timestamp.now());

      await firestore.collection('invites').doc(invite.id).set(invite.toJson());
    }
  }

  @override
  Future<void> acceptInvite({required String inviteUid}) async {
    DocumentReference inviteRef = firestore.collection('invites').doc(inviteUid);
    DocumentSnapshot inviteSnapshot = await inviteRef.get();
    if (inviteSnapshot.exists) {
      String groupUid = inviteSnapshot.get('groupUid');
      await firestore.collection('groups').doc(groupUid).update({
        'members': FieldValue.arrayUnion([currentUserUid]),
      });
      await inviteRef.delete();
    }
  }

  @override
  Future<void> declineInvite({required String inviteUid}) async {
    await firestore.collection('invites').doc(inviteUid).delete();
  }

  @override
  Future<List<GroupInvite>> getUserInvites() async {
    QuerySnapshot querySnapshot = await firestore
        .collection('invites')
        .where('receiverUid', isEqualTo: currentUserUid)
        .where('status', isEqualTo: 'pending')
        .get();

    List<GroupInvite> invites = querySnapshot.docs.map((doc) {
      return GroupInvite(
        id: doc.id,
        groupUid: doc.get('groupUid'),
        groupName: doc.get('groupName'),
        senderName: doc.get('senderName'),
        receiverUid: doc.get('receiverUid'),
        status: doc.get('status'),
        sentOn: doc.get('sentOn'),
      );
    }).toList();

    return invites;
  }
}
