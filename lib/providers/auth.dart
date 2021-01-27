import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

import '../data/constants.dart';
import '../models/user.dart';

final usersTable = tables['users'];

class Auth with ChangeNotifier {
  CurrentUser currentUser;
  UserCredential authResult;

  final db = FirebaseFirestore.instance;

  //String get roleAsString => currentUser.role.toString().split('.').last;

  bool hasAccess(Entity entity, Operations action) {
    //print('hasAccess : ' + currentUser.role.toString());
    // try {
    //   return permission[currentUser.role][entity][action];
    // } catch (e) {
    //   print('hasAccess : ' + e.toString());
    //   return false;
    // }
    return true;
  }

  Future<void> fetchCurrentUser() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection(usersTable)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      print("email : " + userDoc.get("email"));
      currentUser = CurrentUser(
        id: userDoc.id,
        email: userDoc.get("email"),
        username: userDoc.get("username"),
        //role: getRoleByString(userDoc.get("role")),
        imageURL: null,
        //school: userDoc.get("school"),
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<CurrentUser> fetchUserByEmail(String pattern) async {
    try {
      CurrentUser addedUser;
      print("fetchUserByEmail :  " + pattern);
      final snapshot = await FirebaseFirestore.instance
          .collection(usersTable)
          .where('email', isEqualTo: pattern)
          .get();

      print("fetchUserByEmail :  " + snapshot.size.toString());

      if (snapshot.size == 0 || snapshot.size > 1) {
        print("fetchUserByEmail : No Registered User with " + pattern);
        return null;
      }

      print("fetchUserByEmail");

      snapshot.docs.forEach((doc) async {
        print("email : " + doc.get("email"));
        print("username : " + doc.get("username"));
        print("image_url : " + doc.get("image_url"));
        addedUser = CurrentUser(
          id: doc.id,
          email: doc.get("email"),
          username: doc.get("username"),
          imageURL: doc.get("image_url"),
        );
      });

      //notifyListeners();
      print('addedUser : ' + addedUser.toString());
      return addedUser;
      //return null;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signup(
      String email, String username, String password, File image) async {
    //String defaultRole = 'Student';

    authResult = await (FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ));
    print('Auth User ' + email + ' created');
    var url;
    if (image != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(authResult.user.uid + '.jpg');

      await ref.putFile(image).onComplete;

      url = await ref.getDownloadURL();
    }
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user.uid)
        .set({
      'username': username,
      'email': email,
      'image_url': url,
    });

    print('User ' + email + ' added in users table created');
    currentUser = CurrentUser(
      id: authResult.user.uid,
      email: email,
      username: username,
      imageURL: url,
      //imageURL: image,
      //role: Role.Student,
    );
    notifyListeners();
  }

  static Future<UserCredential> register(String email, String password) async {
    FirebaseApp app = await Firebase.initializeApp(
        name: 'Secondary', options: Firebase.app().options);
    UserCredential userCredential;
    try {
      userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(" FirebaseAuthException : " + e.message.toString());
      // Do something with exception. This try/catch is here to make sure
      // that even if the user creation fails, app.delete() runs, if is not,
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
    }

    await app.delete();
    return Future.sync(() => userCredential);
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

  // Role getRoleByString(String roleStr) {
  //   switch (roleStr) {
  //     case 'Teacher':
  //       return Role.Teacher;
  //     case 'SchoolAdmin':
  //       return Role.SchoolAdmin;
  //     case 'Admin':
  //       return Role.Admin;
  //     default:
  //       return Role.Student;
  //   }
  // }
}
