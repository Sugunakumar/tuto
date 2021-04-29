import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/members.dart';

class SchoolNotifier with ChangeNotifier, Members {
  School _school;

  set school(School newSchool) {
    assert(newSchool != null);
    _school = newSchool;
    notifyListeners();
  }

  School get school => _school;

  List<Class> _classes = [];

  List<Class> get classes {
    //return _classes.toList();
    return _classes.where((i) => i.schoolId == _school.id).toList();
  }

  Class findClassById(String id) {
    return _classes.firstWhere((i) => i.id == id);
  }

  Future<void> fetchAndSetClasses() async {
    final List<Class> loaded = [];
    try {
      final snapshot = await db
          .collection(schoolsTableName)
          .doc(_school.id)
          .collection(classesTableName)
          .get();
      if (snapshot.size == 0) {
        _classes = loaded;
        return;
      }

      print("fetchAndSetClasss");

      snapshot.docs.forEach((doc) async {
        loaded.add(Class(
          schoolId: _school.id,
          id: doc.id,
          name: doc.get('name'),
          grade: doc.get('grade'),
          classTeacher: Teacher(
            user: Member(
                id: doc.get('classTeacher')['userId'],
                email: doc.get('classTeacher')['email'],
                username: doc.get('classTeacher')['name'],
                imageURL: doc.get('classTeacher')['imageURL']),
          ),
        )

            //teacherId: doc.get('teacherId'),

            );
      });

      _classes = loaded;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> addClass(Class item) async {
    final newItem = {
      'name': item.name,
      'grade': item.grade,
      'classTeacher': {
        'userId': item.classTeacher.user.id,
        'name': item.classTeacher.user.username,
        'imageURL': item.classTeacher.user.imageURL,
      }
    };

    //print('classTeacher name : ' + item.classTeacher.name);
    //print('classTeacher image : ' + item.classTeacher.imageURL);

    try {
      final classCollection = db
          .collection(schoolsTableName)
          .doc(_school.id)
          .collection(classesTableName);

      final addedItem = await classCollection.add(newItem);

      final newItemList = Class(
        schoolId: _school.id,
        id: addedItem.id,
        name: item.name,
        grade: item.grade,
        classTeacher: item.classTeacher,
      );

      _classes.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateClass(String id, Class newItem) async {
    final itemIndex = _classes.indexWhere((item) => item.id == id);

    if (itemIndex >= 0) {
      try {
        await db
            .collection(schoolsTableName)
            .doc(_school.id)
            .collection(classesTableName)
            .doc(id)
            .update({
          'name': newItem.name,
          'grade': newItem.grade,
          'classTeacher': {
            'userId': newItem.classTeacher.user.id,
            'name': newItem.classTeacher.user.username,
            'imageURL': newItem.classTeacher.user.imageURL,
          }
        });
        _classes[itemIndex] = newItem;

        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('No such item with id : ' + id);
    }
  }

  Future<void> deleteClass(String id) async {
    final existingItemIndex = _classes.indexWhere((i) => i.id == id);
    var existingItem = _classes[existingItemIndex];
    _classes.removeAt(existingItemIndex);
    notifyListeners();

    try {
      await db
          .collection(schoolsTableName)
          .doc(id)
          .collection(classesTableName)
          .doc(id)
          .delete();
      existingItem = null;
    } catch (e) {
      _classes.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }

// ------------------------------------------------ Teachers ---------------------------------------

  List<Teacher> _teachers = [];

  List<Teacher> get teachers {
    return _teachers.where((i) => i.schoolId == _school.id).toList();
  }

  Teacher findTeacherById(String userId) {
    return _teachers.firstWhere((i) => i.user.id == userId);
  }

  List<Teacher> findTeachersByNamePattern(String pattern) {
    return _teachers
        .where((s) =>
            s.user.username.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<void> fetchAndSetTeachers() async {
    final List<Teacher> loaded = [];
    try {
      // final schoolDoc =
      //     await db.collection(School.tableName).doc(this.id).get();

      // List<String> teachersIds = List.from(schoolDoc.get('teachers'));
      print('teacherIds : ' + _school.teacherIds.length.toString());

      if (_school.teacherIds.isEmpty) {
        return;
      }

      List<Member> membersList =
          await findMemberInList(_school.teacherIds) as List<Member>;

      // final snapshot = await db
      //     .collection(membersTableName)
      //     .where(FieldPath.documentId, whereIn: _school.teacherIds)
      //     .get();

      // if (snapshot.size == 0) {
      //   _teachers = loaded;
      //   print("Something wrong user not found for " +
      //       _school.teacherIds.toString());
      //   return;
      // }
      print("fetchAndSetTeachers");

      membersList.forEach((member) async {
        loaded.add(
          Teacher(
            schoolId: _school.id,
            user: member,
          ),
        );
      });

      _teachers = loaded;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> addTeacher(Member addedUser, bool isAdmin) async {
    // final newItem = {
    //   'user': addedUser.id,
    //   'name': addedUser.username,
    //   'imageURL': addedUser.imageURL,
    // };

    try {
      final schooldoc = db.collection(schoolsTableName).doc(_school.id);

      // // adding to School => teachers collection
      // await schoolCollection
      //     .collection(teachersTableName)
      //     .doc(addedUser.id)
      //     .set(newItem);
      // updating to School  collection

      // add user to admins of the school
      if (isAdmin) {
        await schooldoc.update({
          'admins': FieldValue.arrayUnion([addedUser.id]),
          'teachers': FieldValue.arrayUnion([addedUser.id]),
        });
        print('User ' +
            addedUser.username +
            ' user added as Admins and Teachers');
        _school.adminIds.add(addedUser.id);
      } else {
        // add user to teachers of the school
        await schooldoc.update({
          'teachers': FieldValue.arrayUnion([addedUser.id]),
        });
        print('User ' + addedUser.username + ' user added as Teacher');
      }

      await FirebaseFirestore.instance
          .collection(membersTableName)
          .doc(addedUser.id)
          .update({
        'schools': FieldValue.arrayUnion([_school.id]),
      });

      final newItemList = Teacher(
        schoolId: _school.id,
        user: addedUser,
      );

      _school.teacherIds.add(addedUser.id);
      _teachers.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Future<void> updateTeacher(String userId, Teacher newItem) async {
  //   final itemIndex = _teachers.indexWhere((item) => item.userId == userId);
  //   if (itemIndex >= 0) {
  //     try {
  //       await db
  //           .collection(School.tableName)
  //           .doc(id)
  //           .collection(Teacher.tableName)
  //           .doc(userId)
  //           .update({
  //         'userId': newItem.userId,
  //       });
  //       _teachers[itemIndex] = newItem;
  //       notifyListeners();
  //     } catch (e) {
  //       print(e);
  //       throw e;
  //     }
  //   } else {
  //     print('No such item with userId : ' + userId);
  //   }
  // }

  Future<void> removeTeacher(String userId) async {
    final existingItemIndex = _teachers.indexWhere((i) => i.user.id == userId);
    var existingItem = _teachers[existingItemIndex];
    _teachers.removeAt(existingItemIndex);
    notifyListeners();

    try {
      // removing from school => teachers collections
      // await db
      //     .collection(School.tableName)
      //     .doc(id)
      //     .collection(Teacher.tableName)
      //     .doc(userId)
      //     .delete();
      // existingItem = null;

      // remove from the school collection
      await db.collection(schoolsTableName).doc(_school.id).update({
        'teachers': FieldValue.arrayRemove([userId]),
        // scope for improvement get if the user is Admin and make line only if is admin
        'admins': FieldValue.arrayRemove([userId]),
      });
      // remove from the user collection
      await FirebaseFirestore.instance
          .collection(membersTableName)
          .doc(userId)
          .update({
        'schools': FieldValue.arrayRemove([_school.id]),
      });
    } catch (e) {
      _teachers.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }
}
