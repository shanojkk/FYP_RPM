// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vitalrpm/models/user_model.dart';
import 'package:vitalrpm/screens/auth/auth_wrapper.dart';
import 'package:vitalrpm/widgets/loading_overlay.dart';

class UserProvider extends ChangeNotifier {
  late UserModel loginUser;
  late final FirebaseAuth firebaseAuth;

  void initialize(userId, BuildContext context) async {
    await loadUser(userId, context);
  }

  Future<void> createUser(userId, email, firstname, lastname) async {
    DocumentReference userMasterDocument;
    FirebaseFirestore.instance.runTransaction((transaction) async {
      try {
        loginUser = UserModel();
        userMasterDocument =
            FirebaseFirestore.instance.collection('usermaster').doc();
        loginUser.documentId = userMasterDocument.id;
        loginUser.userId = userId!;
        loginUser.email = email!;
        loginUser.firstName = firstname!;
        loginUser.lastName = lastname!;
        transaction.set(userMasterDocument, {
          'docId': loginUser.documentId,
          'userId': loginUser.userId,
          'emailAddress': loginUser.email,
          'firstName': loginUser.firstName,
          'lastName': loginUser.lastName,
          'country': 'Sri Lanka',
          'mobileNo': loginUser.mobileNo,
          'address': loginUser.address,
          'dateOfReg': Timestamp.now(),
          'lastUpdated': Timestamp.now(),
          'usertype': loginUser.userType,
          'genderId': loginUser.genderId
        });
      } catch (e) {
        print("RegisterAPI - Create User Error - $e");
      }
    });
  }

  Future<void> login(emailController, passwordController) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print("LoginAPI - Login Error Occurred - $e");
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> loadUser(String userID, BuildContext context) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('usermaster')
        .where('userId', isEqualTo: userID)
        .get();

    DocumentSnapshot userDoc = snapshot.docs.first;
    if (!userDoc.exists) return Navigator.pop(context);
    loginUser = UserModel();
    loginUser.userId = userID;
    loginUser.documentId = userDoc.get('docId');
    loginUser.email = userDoc.get('email');
    loginUser.firstName = userDoc.get('firstName');
    loginUser.lastName = userDoc.get('lastName');
    loginUser.address = userDoc.get('address');
    loginUser.country = userDoc.get('country');
    loginUser.mobileNo = userDoc.get('mobileNo');
    loginUser.userType = userDoc.get('userType');
    print('User Logged In - ${loginUser.userType.trim()}');
    notifyListeners();
  }

  void nextScreen() {}
}
