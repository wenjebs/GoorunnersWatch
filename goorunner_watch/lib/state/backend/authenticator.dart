import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:runningapp/database/repository.dart';
import 'package:runningapp/state/auth/constants/constants.dart';
import 'package:runningapp/state/auth/models/auth_results.dart';
import 'package:runningapp/state/auth/typedefs.dart';

class Authenticator {
  // Getters
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  // Logout
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    // await FacebookAuth.instance.logOut(); TODO next time
  }

  // Future<AuthResult> loginWithFacebook() async {
  //   final loginResult = await FacebookAuth.instance.login();
  //   final token = loginResult.accessToken?.token;
  //   if (token == null) {
  //     return AuthResult.aborted;
  //   }
  //   final oauthCredentials = FacebookAuthProvider.credential(token);

  //   try {
  //     await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
  //     return AuthResult.success;
  //   } on FirebaseAuthException catch (e) {
  //     final email = e.email;
  //     final credential = e.credential;
  //     if (e.code == Constants.accountExistsWithDifferentCredentialsError &&
  //         email != null &&
  //         credential != null) {
  //       final providers =
  //           await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
  //       if (providers.contains(Constants.googleCom)) {
  //         await loginWithGoogle();
  //         FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
  //       }
  //       return AuthResult.success;
  //     }
  //     return AuthResult.failure;
  //   }
  // }

  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        Constants.emailScope,
      ],
    );

    await googleSignIn.signOut();

    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;
    final oauthCredentials = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredentials);
      final user = userCredential.user;
      if (user != null) {
        Repository.addUser('users', {
          'email': user.email,
          'uid': user.uid,
        });
      }
      return AuthResult.success;
    } catch (e) {
      return AuthResult.failure;
    }
  }

  Future<void> sendPasswordResetLink(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword)
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
