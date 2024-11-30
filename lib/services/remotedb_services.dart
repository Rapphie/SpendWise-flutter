import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spend_wise/models/UserRemote.dart';

const String USERS_COLLECTION_REF = "users";

class RemoteDbService {
  final _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersRef;

  RemoteDbService() {
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
}
