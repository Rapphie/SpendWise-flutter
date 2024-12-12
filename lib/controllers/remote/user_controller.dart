import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spend_wise/widgets/components/loading_progress.dart';
import 'package:spend_wise/widgets/components/snackbar.dart';
import 'package:spend_wise/constants/app_strings.dart';

class UserController {
  void loginUser({
    String? email,
    String? password,
    required BuildContext context,
  }) async {
    LoadingIndicatorDialog().show(context); // a throbber
    final user = FirebaseAuth.instance.currentUser!;
    Snackbar.showSnackbar("Successfully signed in as ${user.email}", duration: 5);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      LoadingIndicatorDialog().dismiss(); // dismiss the throbber after successful login
      final user = FirebaseAuth.instance.currentUser!;
      Snackbar.showSnackbar("Successfully logged in as ${user.email}");
    } on FirebaseAuthException catch (e) {
      String snackbarMessage;
      switch (e.code) {
        case 'user-not-found':
          snackbarMessage = 'User email not found.';
          break;
        case 'invalid-credential':
          snackbarMessage = 'Incorrect email or password.';
          break;
        case 'invalid-email':
          snackbarMessage = 'Please enter a valid email.';
          break;
        case 'channel-error':
          snackbarMessage = 'Please don\'t leave the fields blank.';
          break;
        default:
          snackbarMessage = 'An error occurred. Please try again.';
      }
      //LoadingIndicatorDialog is an async class need to use Future to resolve it.
      Future.delayed(const Duration(seconds: 1), () {
        LoadingIndicatorDialog().dismiss();
        Snackbar.showSnackbar(snackbarMessage);
      });
    }
  }

  void signupUser({
    String? email,
    String? password,
    String? confirmPassword,
    required BuildContext context,
  }) async {
    LoadingIndicatorDialog().show(context);

    if (password != confirmPassword) {
      snackbarMessage = 'Passwords don\'t match. Please try again.';

      //LoadingIndicatorDialog is an async class need to use Future to resolve it.
      Future.delayed(const Duration(seconds: 1), () {
        LoadingIndicatorDialog().dismiss();
        Snackbar.showSnackbar(snackbarMessage);
      });
    } else {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        LoadingIndicatorDialog().dismiss();
        Snackbar.showSnackbar('User created successfully!');
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case 'email-already-in-use':
            snackbarMessage = 'This email is already in use.';
            break;
          case 'weak-password':
            snackbarMessage = 'Minimum password length is 6.';
            break;
          case 'invalid-email':
            snackbarMessage = 'Please enter a valid email.';
            break;
          case 'channel-error':
            snackbarMessage = 'Please don\'t leave the fields blank.';
            break;
          default:
            snackbarMessage = 'An error occurred. Please try again.';
        }
        Future.delayed(const Duration(seconds: 1), () {
          LoadingIndicatorDialog().dismiss();
          Snackbar.showSnackbar(snackbarMessage);
        });
      }
    }
  }

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Snackbar.showSnackbar("Successfully logged out.");
  }

  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      Snackbar.showSnackbar('Google sign-in aborted or failed.');
      return; // Exit if googleUser is null
    }

    GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
    final user = FirebaseAuth.instance.currentUser!;
    Snackbar.showSnackbar("Successfully signed in as ${user.email}", duration: 5);
  }
}
