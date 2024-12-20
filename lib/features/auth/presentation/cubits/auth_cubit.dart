import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spend_wise/features/auth/domain/entities/app_user.dart';
import 'package:spend_wise/features/auth/domain/repositories/auth_repository.dart';
import 'package:spend_wise/features/auth/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required this.authRepo}) : super(AuthInitial());
  final AuthRepository authRepo;
  AppUser? _currentUser;

  void checkAuth() async {
    try {
      emit(AuthLoading());
      AppUser? user = await authRepo.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user: user, message: 'Already logged in.'));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthFailure(message: 'Failed to check authentication'));
    }
  }

  AppUser? get currentUser => _currentUser;

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signInWithEmailAndPassword(email: email, password: password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user: user, message: 'Successfully logged in as ${user.email}.'));
      } else {
        emit(AuthFailure(message: 'Failed to login.'));
      }
    } catch (e) {
      String message = 'Unknown error. Please try again.';
      if (e.toString().contains('invalid-email')) {
        message = 'Invalid email address.';
      } else if (e.toString().contains('invalid-credential')) {
        message = 'Incorrect email or password.';
      } else if (e.toString().contains('ssl')) {
        message = 'SSL connection error. Please check your network connection.';
      }
      print('Login error: $e'); // Add detailed logging
      emit(AuthFailure(message: message));
      emit(Unauthenticated());
    }
  }

  Future<void> register(
      {required String name, required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final user =
          await authRepo.registerWithEmailAndPassword(name: name, email: email, password: password);
      if (user != null) {
        _currentUser = null; // Clear the current user
        emit(RegistrationSuccess(message: 'Successfully registered. Please log in.'));
      } else {
        emit(AuthFailure(message: 'Failed to register.'));
        emit(Unauthenticated());
      }
    } catch (e) {
      String message = '';
      if (e.toString().contains('invalid-email')) {
        message = 'Invalid email address.';
      } else if (e.toString().contains('weak-password')) {
        message = 'Minimum password length is 6 characters.';
      } else if (e.toString().contains('email-already-in-use')) {
        message = 'Email is already in use.';
      } else {
        message = 'Unknown error. Please try again.';
      }
      print('Registration error: $e'); // Add detailed logging
      emit(AuthFailure(message: message));
      emit(Unauthenticated());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      emit(AuthLoading());
      final user = await authRepo.signInWithGoogle();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user: user, message: 'Successfully logged in as ${user.email}.'));
      } else {
        emit(AuthFailure(message: 'Failed to login with Google.'));
        emit(Unauthenticated());
      }
    } catch (e) {
      print('Google login error: $e'); // Add detailed logging
      emit(AuthFailure(message: 'Error: $e'));
      emit(Unauthenticated());
    }
  }

  Future<void> logout() async {
    authRepo.logout();
    _currentUser = null; // Clear the current user
    emit(Unauthenticated());
  }
}
