import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/school.dart';

import '../data/constants.dart';

//admin@admin.com/admin/admin@123 - SchoolAdmin
//five@test.com/five/welcome@123 - Teacher
//six@test.com/sixtest/welcome@123 - Student

class Auth with ChangeNotifier {
  UserCredential authResult;

  final db = FirebaseFirestore.instance;

  static List<Member> _members = [];

  List<Member> get members {
    return _members.toList();
  }

  static Member _currentMember;
  static School _currentMemberSchool;

  Member get currentMember => _currentMember;
  School get currentMemberSchool => _currentMemberSchool;
  //String get roleAsString => currentUser.role.toString().split('.').last;

  bool hasAccess(Entity entity, Operations action) {
    print('hasAccess : ' + _currentMember.roles.toString());
    try {
      //if (_currentMember.email == "admin@admin.com") return true;
      if (_currentMember.roles != null)
        for (var role in _currentMember.roles) {
          return (permission[role][entity][action] != null)
              ? permission[role][entity][action]
              : false;
        }
      return false;
    } catch (e) {
      print('hasAccess : ' + e.toString());
      return false;
    }
  }

  static Member findById(String id) {
    print("_members : " + _members.length.toString());
    print("id : " + id.toString());
    return _members.firstWhere((i) => i.id == id, orElse: () => null);
  }

  // User fetchCurrentUser() {
  //   return FirebaseAuth.instance.currentUser;
  // }

  bool isAdmin() {
    return FirebaseAuth.instance.currentUser.email.contains('admin@admin.com');
  }

  bool isSchoolAdmin(String schoolId) {
    return belongsToSchool(schoolId) &&
        _currentMember.roles.contains(Role.SchoolAdmin);
  }

  bool isTeacherOfSchool(String schoolId) {
    return belongsToSchool(schoolId) &&
        _currentMember.roles.contains(Role.Teacher);
  }

  bool isStudentOfSchool(String schoolId) {
    return belongsToSchool(schoolId) &&
        _currentMember.roles.contains(Role.Student);
  }

  bool isTeacherOfClass(String classId) {
    return belongsToClass(classId) &&
        _currentMember.roles.contains(Role.Teacher);
  }

  bool isStudentOfClass(String classId) {
    return belongsToClass(classId) &&
        _currentMember.roles.contains(Role.Student);
  }

  bool belongsToSchool(String schoolId) {
    if (_currentMember.schoolId != null)
      return _currentMember.schoolId == schoolId;
    return false;
  }

  bool belongsToClass(String classId) {
    return _currentMember.classIds != null
        ? _currentMember.classIds.contains(classId)
        : false;
  }

  Future<void> fetchCurrentMemeber() async {
    try {
      print('fetchCurrentMemeber');
      final userDoc = await FirebaseFirestore.instance
          .collection(membersTableName)
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();

      _currentMember = Member(
        id: userDoc.id,
        email: userDoc.get("email"),
        username: userDoc.get("username"),
        imageURL: null,
        roles: userDoc.data().containsKey("roles")
            ? getRoleByString(List.from(userDoc.get('roles')))
            : null,
        schoolId: userDoc.data().containsKey("schoolId")
            ? userDoc.get("schoolId")
            : null,
        classIds: userDoc.data().containsKey("classIds")
            ? List.from(userDoc.get("classIds"))
            : null,
      );
      print("Logged in User : " + _currentMember.email);
      print("Roles : " + _currentMember.roles.toString());
      print("SchoolId : " + _currentMember.schoolId.toString());

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<Member> fetchUserByEmail(String pattern) async {
    try {
      Member addedUser;
      print("fetchUserByEmail :  " + pattern);
      final snapshot = await FirebaseFirestore.instance
          .collection(membersTableName)
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
        addedUser = Member(
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

  List<Member> findUserByNameOrEmail(String pattern) {
    try {
      print('pattern :' + pattern);
      if (pattern.isNotEmpty) {
        if (_members.isEmpty)
          fetchAndSetMembers().then((value) {
            print('members : ' + _members.toString());
            return _members
                .where((s) =>
                    s.email.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          });
      }
      return null;
    } catch (e) {
      throw e;
    }
  }

  Future<List<Member>> fetchAndSetMembers({List<String> memberIds}) async {
    final List<Member> loaded = [];
    var snapshot;
    print("memberIds : " + memberIds.toString());
    try {
      if (memberIds == null)
        snapshot =
            await FirebaseFirestore.instance.collection(membersTableName).get();
      else
        snapshot = await FirebaseFirestore.instance
            .collection(membersTableName)
            .where(FieldPath.documentId, whereIn: memberIds)
            .get();

      if (snapshot.size == 0) {
        print("fetchAndSetMembers : No users to display");
        _members = loaded;
        return loaded;
      }

      print("fetchAndSetMembers : " + snapshot.size.toString());

      snapshot.docs.forEach((doc) async {
        loaded.add(
          Member(
            id: doc.id,
            username: doc.get("username"),
            imageURL: doc.data().containsKey('image_url')
                ? doc.get('image_url')
                : null,
            email: doc.data().containsKey('email') ? doc.get('email') : null,
          ),
        );
      });

      for (var member in loaded) {
        final itemIndex = _members.indexWhere((item) => item.id == member.id);
        if (itemIndex < 0) _members.add(member);
      }

      print("members set : " + _members.length.toString());

      return loaded;
    } catch (e) {
      print(e.toString());
      throw (e);
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

      await ref.putFile(image).whenComplete(() => null);

      url = await ref.getDownloadURL();
    }

    await FirebaseFirestore.instance
        .collection(membersTableName)
        .doc(authResult.user.uid)
        .set({
      'username': username,
      'email': email,
      'image_url': url,
    });

    print('User ' + email + ' added in users table created');
    _currentMember = Member(
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
      //await fetchCurrentUser();
    } catch (e) {
      throw e;
    }
    notifyListeners();
  }
}
