import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart" as syspaths;

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolAdmin.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/providers/auth.dart';

class Schools with ChangeNotifier {
  final db = FirebaseFirestore.instance;

  List<School> _schools = [];

  List<School> get schools {
    return _schools.toList();
  }

  List<School> findSchoolsByName(String searchText) {
    if (searchText.isEmpty) {
      return _schools.toList();
    }
    return _schools
        .where((s) => s.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  School findById(String id) {
    return _schools.firstWhere((i) => i.id == id);
  }

  bool isTeacher(String schoolId, String userId) {
    return (findById(schoolId)
                .teachers
                .firstWhere((element) => element.user.id == userId)) !=
            null
        ? true
        : false;
  }

  bool isStudent(String schoolId, String userId) {
    School school = findById(schoolId);
    print('school : ' + school.name);

    // if(school.)
    // check null for students
    return findById(schoolId)
                .students
                .firstWhere((element) => element.user.id == userId) !=
            null
        ? true
        : false;
  }

  // Future<School> fetchAndSetSchool(String schoolId) async {
  //   try {
  //     final doc = await db.collection(schoolsTableName).doc(schoolId).get();

  //     print("fetchAndSet Single School");

  //     return School(
  //       id: doc.id,
  //       name: doc.get('name'),
  //       address: doc.get('address'),
  //       board: doc.get('board'),
  //       imageURL:
  //           doc.data().containsKey('imageURL') ? doc.get('imageURL') : null,
  //       email: doc.data().containsKey('email') ? doc.get('email') : null,
  //       phone: doc.data().containsKey('phone') ? doc.get('phone') : null,
  //       createdBy: doc.get('createdBy'),
  //       createdAt: DateTime.parse(doc.get('createdAt').toDate().toString()),
  //     );
  //   } catch (e) {
  //     print(e.toString());
  //     throw (e);
  //   }
  // }

  // Future<void> fetchAndSetSchoolsOld(
  //     {List<String> schoolIds, bool onlyOrder = false}) async {
  //   final List<School> loaded = [];
  //   var snapshot;
  //   try {
  //     if (schoolIds == null || onlyOrder == true) {
  //       print('before   queary');
  //       snapshot = await db.collection(schoolsTableName).get();
  //       print('after   queary');
  //     } else if (schoolIds.isNotEmpty && onlyOrder == false) {
  //       print('else ' + schoolIds[0].toString());
  //       snapshot = await db
  //           .collection(schoolsTableName)
  //           .where(FieldPath.documentId, whereIn: schoolIds)
  //           .get();
  //     } else
  //       print('to be handles');

  //     if (snapshot.size == 0) {
  //       print("fetchAndSetSchools : No schools to display");
  //       _schools = loaded;
  //       return;
  //     }

  //     print("fetchAndSetSchools " + snapshot.size.toString());

  //     snapshot.docs.forEach((doc) {
  //       loaded.add(
  //         School(
  //           id: doc.id,
  //           name: doc.get('name'),
  //           address: doc.get('address'),
  //           board: doc.get('board'),
  //           imageURL:
  //               doc.data().containsKey('imageURL') ? doc.get('imageURL') : null,
  //           email: doc.data().containsKey('email') ? doc.get('email') : null,
  //           phone: doc.data().containsKey('phone') ? doc.get('phone') : null,
  //           createdBy: doc.get('createdBy'),
  //           createdAt: DateTime.parse(doc.get('createdAt').toDate().toString()),
  //         ),
  //       );
  //     });

  //     if (schoolIds != null)
  //       for (var schoolId in schoolIds) {
  //         final itemIndex = loaded.indexWhere((item) => item.id == schoolId);
  //         await loaded[itemIndex].fetchAndSetTeachers();
  //         await loaded[itemIndex].fetchAndSetClasses();
  //         loaded.insert(0, loaded.removeAt(itemIndex));
  //       }

  //     _schools = loaded;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //     throw (e);
  //   }
  // }

  Future<void> fetchAndSetSchools(Auth auth) async {
    final List<School> loaded = [];
    var snapshot;
    try {
      if (auth.currentMember.roles.contains(Role.SchoolAdmin) || auth.isAdmin())
        snapshot = await db.collection(schoolsTableName).get();
      else if (auth.currentMember.schoolId != null)
        snapshot = await db
            .collection(schoolsTableName)
            .where(FieldPath.documentId, isEqualTo: auth.currentMember.schoolId)
            .get();
      else
        print('to be handled');

      if (snapshot.size == 0) {
        print("fetchAndSetSchools : No schools to display");
        _schools = loaded;
        return;
      }

      print("fetchAndSetSchools " + snapshot.size.toString());

      snapshot.docs.forEach((doc) {
        loaded.add(
          School(
            id: doc.id,
            name: doc.get('name'),
            address: doc.get('address'),
            board: doc.get('board'),
            imageURL:
                doc.data().containsKey('imageURL') ? doc.get('imageURL') : null,
            email: doc.data().containsKey('email') ? doc.get('email') : null,
            phone: doc.data().containsKey('phone') ? doc.get('phone') : null,
            createdBy: doc.get('createdBy'),
            createdAt: DateTime.parse(doc.get('createdAt').toDate().toString()),
          ),
        );
      });

      if (auth.currentMember.schoolId != null) {
        final itemIndex =
            loaded.indexWhere((item) => item.id == auth.currentMember.schoolId);
        await loaded[itemIndex].fetchAndSetTeachers(auth);
        await loaded[itemIndex].fetchAndSetClasses(auth);
        loaded.insert(0, loaded.removeAt(itemIndex));
      }

      _schools = loaded;
      print("fetchAndSetSchools " + _schools.length.toString());
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> add(School item, File image) async {
    final timeStamp = DateTime.now();
    print('add school');
    final newItem = {
      'name': item.name,
      'address': item.address,
      'board': item.board,
      //'imageURL': item.imageURL,
      'email': item.email,
      'phone': item.phone,
      'createdBy': item.createdBy,
      'createdAt': timeStamp,
    };

    try {
      final schoolCollection =
          FirebaseFirestore.instance.collection(schoolsTableName);

      final addedItem = await schoolCollection.add(newItem);

      var imageUrl;

      if (image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('school_images')
            .child(addedItem.id + '.jpg');

        await ref.putFile(image).whenComplete(() => null);

        imageUrl = await ref.getDownloadURL();
      }

      if (imageUrl != null) {
        await schoolCollection.doc(addedItem.id).update({'imageURL': imageUrl});
      }

      final newItemList = School(
        id: addedItem.id,
        name: item.name,
        address: item.address,
        board: item.board,
        imageURL: imageUrl,
        email: item.email,
        phone: item.phone,
        createdBy: item.createdBy,
        createdAt: item.createdAt,
      );

      // final appDir = await syspaths.getApplicationDocumentsDirectory();
      // final savedImage =
      //     await image.copy('${appDir.path}/schools/${newItemList.id}');

      _schools.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> update(String id, School newItem) async {
    final itemIndex = _schools.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(schoolsTableName)
            .doc(id)
            .update({
          'name': newItem.name,
          'address': newItem.address,
          'board': newItem.board,
          'imageURL': newItem.imageURL,
          'email': newItem.email,
          'phone': newItem.phone,
        });

        _schools[itemIndex] = newItem;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('No such item with id : ' + id);
    }
  }

  Future<void> delete(String id) async {
    final existingItemIndex = _schools.indexWhere((i) => i.id == id);
    var existingItem = _schools[existingItemIndex];
    _schools.removeAt(existingItemIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(schoolsTableName)
          .doc(id)
          .delete();
      existingItem = null;
    } catch (e) {
      _schools.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }

// // ======================== Add Teacher ========================

//   Future<void> addTeacher(String schoolId, Member addedUser, int experiance,
//       String qualification) async {
//     // add/update schoolId in users collection

//     final itemIndex = _schools.indexWhere((item) => item.id == schoolId);
//     if (itemIndex >= 0) {
//       try {
//         await db.collection(membersTableName).doc(addedUser.id).update({
//           'schoolIds': schoolId,
//           'roles': FieldValue.arrayUnion(['teacher']),
//         });

//         final timestamp = DateTime.now();

//         // add teacher in schools collection
//         await db
//             .collection(schoolsTableName)
//             .doc(schoolId)
//             .collection(teachersTableName)
//             .doc(addedUser.id)
//             .set({
//           'joiningDate': timestamp,
//           'experiance': experiance,
//           'qualification': qualification
//         });

//         print('User ' + addedUser.username + ' user added as Teacher');

//         final newItemList = SchoolTeacher(
//           joiningDate: timestamp,
//           experiance: experiance,
//           qualification: qualification,
//           user: addedUser,
//         );

//         //_school.teacherIds.add(addedUser.id);
//         _schools[itemIndex].teachers.insert(0, newItemList);

//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such school with id : ' + schoolId);
//     }
//   }

//   Future<void> addAdmin(
//       String schoolId, Member addedUser, String qualification) async {
//     // add/update schoolId in users collection

//     final itemIndex = _schools.indexWhere((item) => item.id == schoolId);
//     if (itemIndex >= 0) {
//       try {
//         await db.collection(membersTableName).doc(addedUser.id).update({
//           'schoolId': schoolId,
//           'roles': FieldValue.arrayUnion(['schoolAdmin']),
//         });

//         final timestamp = DateTime.now();

//         // add teacher in schools collection

//         await db
//             .collection(schoolsTableName)
//             .doc(schoolId)
//             .collection(adminsTableName)
//             .doc(addedUser.id)
//             .set({
//           "joiningDate": timestamp,
//           'qualification': qualification,
//         });

//         print('User ' + addedUser.username + ' user added as Teacher');

//         final newItemList = SchoolAdmin(
//           joiningDate: timestamp,
//           qualification: qualification,
//           user: addedUser,
//         );

//         //_school.teacherIds.add(addedUser.id);
//         _schools[itemIndex].admins.insert(0, newItemList);

//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such school with id : ' + schoolId);
//     }
//   }
}
