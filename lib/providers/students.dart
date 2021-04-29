import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/student.dart';
import '../data/constants.dart';

// class Students with ChangeNotifier {
//   final schoolsTable = tables['schools'];
//   final studentTable = tables['students'];
//   final chapterTable = tables['chapters'];
//   final classesTable = tables['classes'];

//   final db = FirebaseFirestore.instance;

//   List<Student> _students = [];

//   String _schoolId;
//   String _classId;

//   List<Student> get students {
//     return _students.toList();
//   }

//   Student findById(String userId) {
//     return _students.firstWhere((i) => i.userId == userId);
//   }

//   Future<void> fetchAndSetStudents(String schoolId, String classId) async {
//     this._schoolId = schoolId;
//     this._classId = classId;
//     final List<Student> loaded = [];
//     try {
//       final snapshot = await db
//           .collection(schoolsTable)
//           .doc(_schoolId)
//           .collection(classesTable)
//           .doc(classId)
//           .collection(studentTable)
//           .get();

//       if (snapshot.size == 0) {
//         _students = loaded;
//         print("fetchAndSetStudents : No students to display");
//         return;
//       }

//       print("fetchAndSetStudents");

//       snapshot.docs.forEach((doc) async {
//         loaded.add(
//           Student(
//             userId: doc.id,
//             name: doc.get('name'),
//             imageURL:
//                 doc.data().containsKey('imageURL') ? doc.get('imageURL') : "",
//           ),
//         );
//       });

//       _students = loaded;
//       notifyListeners();
//     } catch (e) {
//       print(e.toString());
//       throw (e);
//     }
//   }

//   Future<void> addStudent(CurrentUser addedUser) async {
//     final newItem = {
//       'userId': addedUser.id,
//       'name': addedUser.username,
//       'imageURL': addedUser.imageURL,
//     };

//     try {
//       final classCollection = db
//           .collection(schoolsTable)
//           .doc(_schoolId)
//           .collection(classesTable)
//           .doc(_classId);

//       // adding to School => teachers collection
//       await classCollection
//           .collection(studentTable)
//           .doc(addedUser.id)
//           .set(newItem);
//       // updating to School  collection
//       await classCollection.update({
//         'teachers': FieldValue.arrayUnion([addedUser.id]),
//       });

//       print('User ' + addedUser.username + ' user added as Student');

//       final newItemList = Student(
//         userId: addedUser.id,
//         name: addedUser.username,
//         imageURL: addedUser.imageURL,
//       );

//       _students.insert(0, newItemList);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> updateStudent(String userId, Student newItem) async {
//     final itemIndex = _students.indexWhere((item) => item.userId == userId);
//     if (itemIndex >= 0) {
//       try {
//         await db
//             .collection(schoolsTable)
//             .doc(_schoolId)
//             .collection(classesTable)
//             .doc(_classId)
//             .collection(studentTable)
//             .doc(userId)
//             .update({
//           'userId': newItem.userId,
//         });
//         _students[itemIndex] = newItem;
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such item with id : ' + userId);
//     }
//   }

//   Future<void> deleteStudent(String userId) async {
//     final existingItemIndex = _students.indexWhere((i) => i.userId == userId);
//     var existingItem = _students[existingItemIndex];
//     _students.removeAt(existingItemIndex);
//     notifyListeners();

//     try {
//       await db
//           .collection(schoolsTable)
//           .doc(_schoolId)
//           .collection(classesTable)
//           .doc(_classId)
//           .collection(studentTable)
//           .doc(userId)
//           .delete();
//       existingItem = null;
//       // updating the school collection
//       await db
//           .collection(schoolsTable)
//           .doc(_schoolId)
//           .collection(classesTable)
//           .doc(_classId)
//           .update({
//         'students': FieldValue.arrayRemove([userId])
//       });
//     } catch (e) {
//       _students.insert(existingItemIndex, existingItem);
//       notifyListeners();
//       throw e;
//     }
//   }
// }
