import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spend_wise/models/User/UserRemote.dart';
import 'package:spend_wise/widgets/components/snackbar.dart';

const String USERS_COLLECTION_REF = "users";

class UserRemoteDb {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  UserRemoteDb() {
    _usersRef = _firestore.collection(USERS_COLLECTION_REF).withConverter<UserRemote>(
        fromFirestore: (snapshots, _) => UserRemote.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (user, _) => user.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    // Snackbar.showSnackbar('got the users');
    return _usersRef.snapshots();
  }

  void addUser(UserRemote user) async {
    // Snackbar.showSnackbar('added the user');
    _usersRef.add(user);
  }

  void updateUser(String userid, UserRemote user) {
    // Snackbar.showSnackbar('updated the user');
    _usersRef.doc(userid).update(user.toJson());
  }

  void deleteUser(String userid) {
    // Snackbar.showSnackbar('deleted the user');
    _usersRef.doc(userid).delete();
  }
}
