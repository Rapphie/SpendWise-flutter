// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
// import 'package:spend_wise/features/auth/domain/repositories/auth_repo.dart';

// class FirebaseAuthRepo implements AuthRepo {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   @override
//   Future<AppUser?> loginWithEmailAndPassword({required String email, required String password}) async {
//     try {
//       UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       AppUser user = AppUser(
//         uid: userCredential.user!.uid,
//         email: email,
//         name: '',
//       );

//       return user;
//     } catch (e) {
//       throw Exception('Failed to login: $e');
//     }
//   }

//   @override
//   Future<AppUser?> registerWithEmailAndPassword(
//       {required String name, required String email, required String password}) async {
//     try {
//       UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       AppUser user = AppUser(
//         uid: userCredential.user!.uid,
//         email: email,
//         name: name,
//       );

//       return user;
//     } catch (e) {
//       throw Exception('Failed to login: $e');
//     }
//   }

//   @override
//   Future<void> logout() {
//     FirebaseAuth.instance.signOut();
//     throw UnimplementedError();
//   }

//   @override
//   Future<AppUser?> getCurrentUser() async {
//     final firebaseUser = _firebaseAuth.currentUser;

//     if (firebaseUser == null) {
//       return null;
//     }

//     return AppUser(
//       uid: firebaseUser.uid,
//       email: firebaseUser.email!,
//       name: '',
//     );
//   }

//   @override
//   Future<void> resetPassword({required String email}) async {
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       throw Exception('Failed to send password reset email: $e');
//     }
//   }
// }
