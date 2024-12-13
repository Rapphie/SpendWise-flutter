import 'package:spend_wise/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> signInWithEmailAndPassword({required String email, required String password});

  Future<AppUser?> registerWithEmailAndPassword(
      {required String name, required String email, required String password});
  Future<void> logout();
  Future<AppUser?> getCurrentUser();
  Future<void> resetPassword({required String email});
  Future<AppUser?> signInWithGoogle();
}
