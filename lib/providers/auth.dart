import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:tuto/data/constants.dart';
import '../models/user.dart';

import '../models/http_exception.dart';

final usersTable = tables['users'];

class Auth with ChangeNotifier {
  CurrentUser currentUser;
  UserCredential authResult;

  String get roleAsString => currentUser.role.toString().split('.').last;

  bool hasAccess(Entity entity, Operations action) {
    try {
      return permission[currentUser.role][entity][action];
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(usersTable)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      print("email : " + userDoc.get("email"));
      print("role : " + userDoc.get("role"));
      currentUser = CurrentUser(
        id: userDoc.id,
        email: userDoc.get("email"),
        username: userDoc.get("username"),
        role: getRoleByString(userDoc.get("role")),
        image: null,
        //school: userDoc.get("school"),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(
      String email, String username, String password, File image) async {
    String defaultRole = 'Student';
    authResult = await (FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ));

    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child(authResult.user.uid + '.jpg');

    await ref.putFile(image).onComplete;

    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user.uid)
        .set({
      'username': username,
      'email': email,
      'image_url': url,
      'role': defaultRole,
    });
    currentUser = CurrentUser(
      id: authResult.user.uid,
      email: email,
      username: username,
      image: image,
      role: Role.Student,
    );
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await fetchCurrentUser();
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }

  Role getRoleByString(String roleStr) {
    switch (roleStr) {
      case 'Teacher':
        return Role.Teacher;
      case 'SchoolAdmin':
        return Role.SchoolAdmin;
      case 'Admin':
        return Role.Admin;
      default:
        return Role.Student;
    }
  }
}
