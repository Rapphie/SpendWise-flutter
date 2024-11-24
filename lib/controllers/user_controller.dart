import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spend_wise/widgets/components/loading_progress.dart';
import 'package:spend_wise/widgets/components/snackbar.dart';
import 'package:spend_wise/constants/app_strings.dart';

class UserController {
  final Snackbar snackbar = Snackbar();

  void loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    LoadingIndicatorDialog().show(context);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      LoadingIndicatorDialog().dismiss();
      final user = FirebaseAuth.instance.currentUser!;
      Snackbar.showSnackBar("Successfully signed in as ${user.email}",
          duration: 5);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          snackbarMessage = 'User email not found.';
          break;
        case 'invalid-credential':
          snackbarMessage = 'Incorrect email or password.';
          break;
        case 'channel-error':
          snackbarMessage = 'Please don\'t leave the fields blank.';
          break;
        default:
          snackbarMessage = 'An error occurred. Please try again.';
      }
      Future.delayed(const Duration(seconds: 1), () {
        LoadingIndicatorDialog().dismiss();
        Snackbar.showSnackBar(snackbarMessage);
      });
    }
    LoadingIndicatorDialog().dismiss();
  }

  void signupUser({
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    LoadingIndicatorDialog().show(context);

    if (password != confirmPassword) {
      snackbarMessage = 'Passwords don\'t match. Please try again.';
      Snackbar.showSnackBar(snackbarMessage);
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        LoadingIndicatorDialog().dismiss();
        Snackbar.showSnackBar('User created successfully!');
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            snackbarMessage = 'This email is already in use.';
            break;
          case 'weak-password':
            snackbarMessage = 'Minimum password length is 6.';
            break;
          case 'invalid-email':
            snackbarMessage = 'The email format is invalid.';
            break;
          case 'channel-error':
            snackbarMessage = 'Please don\'t leave the fields blank.';
            break;
          default:
            snackbarMessage = 'An error occurred. Please try again.';
        }
        Future.delayed(const Duration(seconds: 1), () {
          LoadingIndicatorDialog().dismiss();
          Snackbar.showSnackBar(snackbarMessage, duration: 5);
        });
      }
    }
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Snackbar.showSnackBar("Successfully logged out.", duration: 5);
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Snackbar.showSnackBar('Google sign-in aborted or failed.');
      return; // Exit if googleUser is null
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    Snackbar.showSnackBar(
        userCredential.user?.displayName ?? 'No display name available');
    Snackbar.showSnackBar("Successfully logged in!", duration: 5);
  }
}
