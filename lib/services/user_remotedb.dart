import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spend_wise/models/User/UserRemote.dart';

const String USERS_COLLECTION_REF = "users";

class UserRemoteDb {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  UserRemoteDb() {
    _usersRef =
        _firestore.collection(USERS_COLLECTION_REF).withConverter<UserRemote>(
            fromFirestore: (snapshots, _) => UserRemote.fromJson(
                  snapshots.data()!,
                ),
            toFirestore: (user, _) => user.toJson());
  }

  Stream<QuerySnapshot> getTodos() {
    return _usersRef.snapshots();
  }

  void addUser(UserRemote user) async {
    _usersRef.add(user);
  }

  void updateUser(String userid, UserRemote user) {
    _usersRef.doc(userid).update(user.toJson());
  }

  void deleteUser(String userid) {
    _usersRef.doc(userid).delete();
  }
}
