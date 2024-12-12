import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spend_wise/models/Group/GroupRemote.dart';

const String GROUPS_COLLECTION_REF = "groups";

class GroupRemoteDb {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _groupsRef;

  GroupRemoteDb() {
    _groupsRef = _firestore.collection(GROUPS_COLLECTION_REF).withConverter<GroupRemote>(
          fromFirestore: GroupRemote.fromFirestore,
          toFirestore: (GroupRemote group, options) => group.toFirestore(),
        );
  }

  Stream<QuerySnapshot> getGroups() {
    return _groupsRef.snapshots();
  }

  void addGroup(GroupRemote group) async {
    _groupsRef.add(group);
  }

  void updateUser(String groupid, GroupRemote group) {
    _groupsRef.doc(groupid).update(group.toFirestore());
  }

  void deleteUser(String groupid) {
    _groupsRef.doc(groupid).delete();
  }
}
