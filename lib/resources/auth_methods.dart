// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/models/user.dart';
import '/resources/storage_methods.dart';
import '../controller/user_provider.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'Some error Occurred';
    String errorDes = '';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          bio.isNotEmpty &&
          file != null) {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);
        res = 'success';
        UserModel userModel = UserModel(
            username: username,
            uid: user.user!.uid,
            email: email,
            bio: bio,
            photoUrl: photoUrl,
            follower: [],
            following: [],
            status: "Online");
        await _firestore
            .collection('users')
            .doc(user.user!.uid)
            .set(userModel.toMap());
      } else {
        res = 'Invalid Credentials';
        errorDes =
            "Please Try to enter all the fields and choose your profile image.";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        res = 'Email Already In Use';
        errorDes =
            "This email is already in use by another account. Try another email or login with this email.";
      }
      if (error.code == 'weak-password') {
        res = 'Weak Password';
        errorDes =
            "Pick a strong password. Use a combination of at least six numbers, letters and special characters.";
      }
    }
    return [res, errorDes];
  }

  loginUser({required String email, required String password}) async {
    String res = 'Some error Occurred';
    String errorDes = '';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        res = "Incorrect Username/Password";
        errorDes =
            "The username or password you entered doesn't appear to belong to an account. Please check your username and password and try again.";
      }
    } on FirebaseAuthException catch (error) {
      if (error.code == 'wrong-password') {
        res = "Incorrect Password";
        errorDes =
            "The password you entered doesn't appear to belong to an account. Please check your password and try again.";
      }
      if (error.code == 'too-many-requests') {
        res = "Incorrect Password";
        errorDes =
            "You've entered the wrong password too many times, try again later.";
      }
      if (error.code == 'user-not-found') {
        res = "No Account Associated";
        errorDes =
            "Email you've entered is not associated with any account, try signing up or login with another credential.";
      }
      debugPrint(error.code);
    }
    return [res, errorDes];
  }

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    UserModel user = UserModel.fromMap(snap.data() as Map<String, dynamic>);
    return user;
  }

  signOut() async {
    await _auth.signOut();
  }

  getUserData(BuildContext context) async {
    UserProvider userProvider = Provider.of(context, listen: false)
      ..refreshUser();
    await userProvider.refreshUser();
  }
}
