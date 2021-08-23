import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/schoolAdmin.dart';
import 'package:tuto/new_providers/schoolStudent.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/providers/auth.dart';

class School with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final String medium;
  final String createdBy;
  final DateTime createdAt;
  final String board;
  final String imageURL;
  String email;
  String phone;

  List<Class> _classes;
  List<SchoolTeacher> _teachers;
  List<SchoolAdmin> _admins;
  List<SchoolStudent> _students;

  School({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.board,
    @required this.imageURL,
    this.medium = "English",
    this.createdBy,
    this.createdAt,
    this.email,
    this.phone,
  });

  List<SchoolTeacher> get teachers => _teachers;
  List<Class> get classes => _classes;
  List<SchoolAdmin> get admins => _admins;
  List<SchoolStudent> get students => _students;

// ============================================ Utils =================================

  Class findClassById(String id) {
    return _classes.firstWhere((i) => i.id == id);
  }

  SchoolStudent findStudentById(String id) {
    return _students.firstWhere((i) => i.user.id == id);
  }

  List<SchoolStudent> findStudentByNamePattern(String pattern) {
    return _students
        .where((s) =>
            s.user.username.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  List<Class> findClassByNamePattern(String pattern) {
    return _classes
        .where((s) =>
            s.name.toLowerCase().contains(pattern.toLowerCase()) ||
            s.icon.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
    // ||
    // s.classTeacher.user.username
    //     .toLowerCase()
    //     .contains(pattern.toLowerCase()))
  }

  List<String> findGradesForClasses(List<Class> classes) {
    List<String> grades = [];
    _classes.forEach((element) {
      grades.add(element.grade.toString().split('.').last);
    });
    return grades;
  }

  SchoolTeacher findTeacherById(String userId) {
    return _teachers.firstWhere((i) => i.user.id == userId, orElse: () => null);
  }

  List<SchoolTeacher> findTeachersByNamePattern(String pattern) {
    return _teachers
        .where((s) =>
            s.user.username.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

// ============================================ Class =================================
  Future<List<Class>> fetchAndSetClasses(Auth auth) async {
    final List<Class> loaded = [];
    var snapshot;
    try {
      if (auth.currentMember.roles.contains(Role.SchoolAdmin) || auth.isAdmin())
        snapshot = await db
            .collection(schoolsTableName)
            .doc(this.id)
            .collection(classesTableName)
            .get();
      else if (auth.currentMember.classIds != null)
        snapshot = await db
            .collection(schoolsTableName)
            .doc(this.id)
            .collection(classesTableName)
            .where(FieldPath.documentId, whereIn: auth.currentMember.classIds)
            .get();
      else
        print('to be handled');

      if (snapshot.size == 0) {
        _classes = loaded;
        return loaded;
      }

      print("fetchAndSetClasss : " + snapshot.size.toString());

      snapshot.docs.forEach((doc) {
        loaded.add(Class(
            //schoolId: _school.id,
            id: doc.id,
            name: doc.get('name'),
            icon: doc.get('icon'),
            grade: getGradeByString(doc.get('grade')),
            academicYear: doc.get('academicYear'),
            classTeacher: doc.data().containsKey('classTeacher')
                ? findTeacherById(doc.get('classTeacher')['userId'])
                : null
            // ? ClassTeacher(
            //     joiningDate: DateTime.parse(doc
            //         .get('classTeacher')['joiningDate']
            //         .toDate()
            //         .toString()),
            //     schoolTeacher:
            //         findTeacherById(doc.get('classTeacher')['userId']))
            // : null,
            ));
      });

      // for (var classId in classIds) {
      //   final itemIndex = loaded.indexWhere((item) => item.id == classId);
      //   loaded.insert(0, loaded.removeAt(itemIndex));
      // }

      _classes = loaded;
      print("classes set : " + _classes.length.toString());

      notifyListeners();
      return loaded;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> addClass(Class item) async {
    final newItem = {
      'name': item.name,
      'grade': getStringByGrade(item.grade),
      'icon': item.icon,
      'academicYear': item.academicYear,
      'classTeacher': {
        'joiningDate': DateTime.now(),
        'userId': item.classTeacher.user.id
      },
    };

    print('classTeacher : ' + item.classTeacher.user.email);

    try {
      final classCollection =
          db.collection(schoolsTableName).doc(id).collection(classesTableName);

      final addedItem = await classCollection.add(newItem);

      final newItemList = Class(
        id: addedItem.id,
        name: item.name,
        icon: item.icon,
        grade: item.grade,
        academicYear: item.academicYear,
        classTeacher: item.classTeacher,
      );

      _classes.insert(0, newItemList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateClass(String classId, Class newItem) async {
    final itemIndex = _classes.indexWhere((item) => item.id == classId);

    if (itemIndex >= 0) {
      try {
        await db
            .collection(schoolsTableName)
            .doc(id)
            .collection(classesTableName)
            .doc(classId)
            .update({
          'name': newItem.name,
          'grade': getStringByGrade(newItem.grade),
          'classTeacher': {
            'joiningDate': DateTime.now(),
            'userId': newItem.classTeacher.user.id
          },
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

  Future<void> fetchAndSetTeachers(Auth auth) async {
    final List<SchoolTeacher> loaded = [];
    try {
      final snapshot = await db
          .collection(schoolsTableName)
          .doc(this.id)
          .collection(teachersTableName)
          .get();
      if (snapshot.size == 0) {
        print("fetchAndSetTeachers : No teachers to display");
        _teachers = loaded;
        return;
      }

      print("fetchAndSetTeachers : " + snapshot.size.toString());

      List<String> userIds = [];

      snapshot.docs.forEach((doc) async {
        userIds.add(doc.id);
      });

      List<Member> members = await auth.fetchAndSetMembers(memberIds: userIds);

      snapshot.docs.forEach((doc) async {
        userIds.add(doc.id);
        loaded.add(
          SchoolTeacher(
            qualification: doc.data().containsKey('qualification')
                ? doc.get('qualification')
                : null,
            experience: doc.data().containsKey('experience')
                ? doc.get('experience')
                : null,
            user: members.firstWhere((element) => element.id == doc.id),
            salary: doc.data().containsKey('salary') ? doc.get('salary') : null,
            joiningDate:
                DateTime.parse(doc.get('joiningDate').toDate().toString()),
          ),
        );
      });

      _teachers = loaded;

      print("teachers set  : " + _teachers.length.toString());
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> addSchoolTeacher(SchoolTeacher schoolTeacher) async {
    try {
      // add/update schoolId in users collection
      await db.collection(membersTableName).doc(schoolTeacher.user.id).update({
        'schoolId': this.id,
        'roles': FieldValue.arrayUnion(['teacher']),
      });

      final timestamp = DateTime.now();

      // add teacher in schools collection
      await db
          .collection(schoolsTableName)
          .doc(this.id)
          .collection(teachersTableName)
          .doc(schoolTeacher.user.id)
          .set({
        'joiningDate': timestamp,
        'experience': schoolTeacher.experience,
        'qualification': schoolTeacher.qualification,
        'salary': schoolTeacher.salary,
      });

      print('User ' + schoolTeacher.user.username + ' user added as Teacher');

      final newItemList = SchoolTeacher(
        joiningDate: timestamp,
        experience: schoolTeacher.experience,
        qualification: schoolTeacher.qualification,
        user: schoolTeacher.user,
        salary: schoolTeacher.salary,
      );

      //_school.teacherIds.add(addedUser.id);

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
      // remove from the school collection
      await db
          .collection(schoolsTableName)
          .doc(id)
          .collection(teachersTableName)
          .doc(existingItem.user.id)
          .delete();

      // remove from the user collection
      await FirebaseFirestore.instance
          .collection(membersTableName)
          .doc(userId)
          .update({
        'schoolId': FieldValue.delete(),
      });
      existingItem = null;
    } catch (e) {
      _teachers.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }

  // ========================================= School Student ============================

  Future<void> fetchAndSetStudents(Auth auth) async {
    final List<SchoolStudent> loaded = [];
    try {
      final snapshot = await db
          .collection(schoolsTableName)
          .doc(this.id)
          .collection(studentsTableName)
          .get();
      if (snapshot.size == 0) {
        print("fetchAndSetStudents : No students to display");
        _students = loaded;
        return;
      }

      print("fetchAndSetStudents : " + snapshot.size.toString());

      List<String> userIds = [];

      snapshot.docs.forEach((doc) async {
        userIds.add(doc.id);
      });

      List<Member> members = await auth.fetchAndSetMembers(memberIds: userIds);

      snapshot.docs.forEach((doc) async {
        userIds.add(doc.id);
        loaded.add(
          SchoolStudent(
            fatherName: doc.get('fatherName'),
            motherName: doc.get('motherName'),
            previousSchool: doc.data().containsKey('previousSchool')
                ? doc.get('previousSchool')
                : null,
            previousSchoolGrade: doc.data().containsKey('previousSchoolGrade')
                ? getGradeByString(doc.get('previousSchoolGrade'))
                : null,
            studenNumber: doc.data().containsKey('studenNumber')
                ? doc.get('studenNumber')
                : null,
            dateOfBirth:
                DateTime.parse(doc.get('joiningDate').toDate().toString()),
            joiningDate:
                DateTime.parse(doc.get('joiningDate').toDate().toString()),
            user: members.firstWhere((element) => element.id == doc.id),
            totalFee: doc.data().containsKey('totalFee')
                ? int.parse(doc.get('totalFee').toString())
                : null,
            paidFee: doc.data().containsKey('paidFee')
                ? int.parse(doc.get('paidFee').toString())
                : null,
          ),
        );
      });

      _students = loaded;

      print("students set  : " + _students.length.toString());
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> addSchoolStudent(SchoolStudent schoolStudent) async {
    try {
      // add/update schoolId in users collection
      await db.collection(membersTableName).doc(schoolStudent.user.id).update({
        'schoolId': this.id,
        'roles': FieldValue.arrayUnion(['student']),
      });

      final timestamp = DateTime.now();

      // add students in schools collection
      await db
          .collection(schoolsTableName)
          .doc(this.id)
          .collection(studentsTableName)
          .doc(schoolStudent.user.id)
          .set({
        'joiningDate': timestamp,
        'fatherName': schoolStudent.fatherName,
        'motherName': schoolStudent.motherName,
        'previousSchoolName': schoolStudent.previousSchool,
        'previousSchoolGrade':
            getStringByGrade(schoolStudent.previousSchoolGrade),
        'studentNumber': schoolStudent.studenNumber,
        'dateOfBirth': schoolStudent.dateOfBirth,
        //'totalFee': schoolStudent.totalFee,
        //'paidFee': schoolStudent.paidFee,
      });

      print('User ' + schoolStudent.user.username + ' user added as Student');

      final newItemList = SchoolStudent(
        joiningDate: timestamp,
        fatherName: schoolStudent.fatherName,
        motherName: schoolStudent.motherName,
        previousSchool: schoolStudent.previousSchool,
        previousSchoolGrade: schoolStudent.previousSchoolGrade,
        dateOfBirth: schoolStudent.dateOfBirth,
        studenNumber: schoolStudent.studenNumber,
        // totalFee: schoolStudent.totalFee,
        // paidFee: schoolStudent.paidFee,
        user: schoolStudent.user,
      );

      //_school.teacherIds.add(addedUser.id);
      _students.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateStudent(String studentId, SchoolStudent newItem) async {
    final itemIndex = _classes.indexWhere((item) => item.id == id);

    if (itemIndex >= 0) {
      try {
        await db
            .collection(schoolsTableName)
            .doc(id)
            .collection(studentsTableName)
            .doc(studentId)
            .update({
          'joiningDate': newItem.joiningDate,
          'fatherName': newItem.fatherName,
          'motherName': newItem.motherName,
          'previousSchoolName': newItem.previousSchool,
          'previousSchoolGrade': newItem.previousSchoolGrade,
          'studentNumber': newItem.studenNumber,
          'dateOfBirth': newItem.dateOfBirth,
          'totalFee': newItem.totalFee,
          'paidFee': newItem.paidFee,
        });
        _students[itemIndex] = newItem;

        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('No such item with id : ' + id);
    }
  }

  Future<void> removeStudent(String userId) async {
    final existingItemIndex = _students.indexWhere((i) => i.user.id == userId);
    var existingItem = _students[existingItemIndex];
    _students.removeAt(existingItemIndex);
    notifyListeners();

    try {
      // remove from the school collection
      await db
          .collection(schoolsTableName)
          .doc(id)
          .collection(studentsTableName)
          .doc(existingItem.user.id)
          .delete();

      // remove from the user collection
      await FirebaseFirestore.instance
          .collection(membersTableName)
          .doc(userId)
          .update({
        'schoolId': FieldValue.delete(),
      });
      existingItem = null;
    } catch (e) {
      _students.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }
}
