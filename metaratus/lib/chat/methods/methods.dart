// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<User?> createAccount(String name, String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    User? user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      debugPrint('Account created successfully');

      // user.updateDisplayName(name);
      user.updateDisplayName(name);
      await _firestore.collection('users').doc(_auth.currentUser?.uid).set({
        "name": name,
        "email": email,
        "status": 'Unavailable',
      });
      return user;
    } else {
      debugPrint('Account creation failed');
      return user;
    }
  } catch (e) {
    debugPrint(e as String?);
    return null;
  }
}

Future<User?> logIn(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    User? user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;

    if (user != null) {
      debugPrint('login successful');
      return user;
    } else {
      debugPrint('login failed');
      return user;
    }
  } catch (e) {
    debugPrint(e as String?);
    return null;
  }
}

Future logOut(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    await _auth.signOut().then((value) {});
  } catch (e) {
    debugPrint('error');
  }
}
