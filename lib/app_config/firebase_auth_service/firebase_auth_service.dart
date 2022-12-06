import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';

class FirebaseAuthService {
  const FirebaseAuthService._private();

  static const FirebaseAuthService _instance = FirebaseAuthService._private();

  static FirebaseAuthService get instance => _instance;

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> signUpResponse = {
      "isSignUp": false,
      "message": "",
    };
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      signUpResponse.putIfAbsent("userDetails", () => userCredential.user);
      signUpResponse.update("message", (value) => "User created successfully.");
      signUpResponse.update("isSignUp", (value) => true);
      return signUpResponse;
    } on FirebaseAuthException catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      signUpResponse.update(
          "message",
          (value) => e.code == 'network-request-failed'
              ? 'Please make sure device is connected to your network.'
              : e.message);
      return signUpResponse;
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> signInResponse = {
      "isSignIn": false,
      "message": "",
    };
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      signInResponse.putIfAbsent("userDetails", () => userCredential.user);
      signInResponse.update("message", (value) => "Sign in successfully");
      signInResponse.update("isSignIn", (value) => true);
      return signInResponse;
    } on FirebaseAuthException catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
      signInResponse.update(
          "message",
          (value) => e.code == 'network-request-failed'
              ? 'Please make sure device is connected to your network.'
              : e.message);
      return signInResponse;
    }
  }

  Future<Map<String, dynamic>> resetPassword({required String email}) async {
    Map<String, dynamic> resetPasswordResponse = {};
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      resetPasswordResponse.putIfAbsent('isSendEmail', () => true);
      resetPasswordResponse.putIfAbsent(
          'msg',
          () =>
              'Reset password link sent successfully to your registered email.');
    } on FirebaseAuthException catch (e, s) {
      resetPasswordResponse.putIfAbsent('isSendEmail', () => false);
      resetPasswordResponse.putIfAbsent(
          'msg',
          () => e.code == 'network-request-failed'
              ? 'Please make sure device is connected to your network.'
              : e.message);
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
    return resetPasswordResponse;
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }
}
