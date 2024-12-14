import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spend_wise/features/group/domain/entities/group_invite.dart';
import 'package:spend_wise/features/group/domain/repositories/invite_repository.dart';

class InviteRepoImpl implements InviteRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Future<void> sendInvite({required String groupUid, required String memberUid}) async {
    String inviteId = firestore.collection('groups').doc().id;

    DocumentSnapshot groupRef = await firestore.collection('groups').doc(groupUid).get();
    String groupName = groupRef.get('name');
    final invite = GroupInvite(
        id: inviteId,
        groupUid: groupUid,
        groupName: groupName,
        senderUid: currentUserUid,
        receiverUid: memberUid,
        status: 'pending',
        sentOn: Timestamp.now());
        
    await firestore.collection('invites').doc(invite.id).set(invite.toJson());
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
      await inviteRef.update({'status': 'accepted'});
    }
  }

  @override
  Future<void> declineInvite({required String inviteUid}) async {
    await firestore.collection('invites').doc(inviteUid).update({
      'status': 'declined',
    });
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
        senderUid: doc.get('senderUid'),
        receiverUid: doc.get('receiverUid'),
        status: doc.get('status'),
        sentOn: doc.get('sentOn'),
      );
    }).toList();

    return invites;
  }
}
