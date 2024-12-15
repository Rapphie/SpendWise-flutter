import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/auth/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spend_wise/features/group/domain/entities/app_group.dart';

class AuthRepoImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebasefirestore = FirebaseFirestore.instance;

  @override
  Future<AppUser?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        name: '',
        groups: [],
        createdOn: null,
        updatedOn: null,
      );

      return user;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<AppUser?> registerWithEmailAndPassword(
      {required String name, required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String groupId = firebasefirestore.collection('groups').doc().id;

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        groups: [groupId],
        createdOn: Timestamp.now(),
        updatedOn: Timestamp.now(),
      );
      AppGroup group = AppGroup(
        uid: groupId,
        name: 'Personal',
        ownerId: user.uid,
        memberList: [user.uid],
        createdOn: Timestamp.now(),
        updatedOn: Timestamp.now(),
      );

      await firebasefirestore.collection('users').doc(user.uid).set(
            user.toJson(),
          );

      await firebasefirestore.collection('groups').doc(groupId).set(
            group.toJson(),
          );
      return user;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      String groupId = firebasefirestore.collection('groups').doc().id;

      AppUser user = AppUser(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email!,
        name: userCredential.user!.displayName ?? '',
        groups: ['personal'],
        createdOn: Timestamp.now(),
        updatedOn: Timestamp.now(),
      );
      AppGroup group = AppGroup(
        uid: groupId,
        name: 'Personal',
        ownerId: user.uid,
        memberList: [user.uid],
        createdOn: Timestamp.now(),
        updatedOn: Timestamp.now(),
      );

      await firebasefirestore.collection('users').doc(user.uid).set(
            user.toJson(),
          );

      await firebasefirestore.collection('groups').doc(groupId).set(
            group.toJson(),
          );
      return user;
    } catch (e) {
      throw Exception('Failed to login with Google: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Failed to logout: $e');
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email!,
      name: '',
      groups: [],
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Failed to send password reset email: $e');
    }
  }
}
