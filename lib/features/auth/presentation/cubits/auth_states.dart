import 'package:spend_wise/features/auth/domain/entities/app_user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final AppUser user;
  final String message;

  Authenticated({required this.user, required this.message});
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

class RegistrationSuccess extends AuthState {
  final String message;
  RegistrationSuccess({required this.message});
}
