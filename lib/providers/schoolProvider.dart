import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/models/models.dart';

// class SchoolProvider with ChangeNotifier {
//   final db = FirebaseFirestore.instance;

//   List<Class> _classes = [];
//   List<Teacher> _teachers = [];

//   School _school;

//   School get school => _school;

//   set school(School newSchool) {
//     assert(newSchool != null);
//     // assert(_itemIds.every((id) => newCatalog.getById(id) != null),
//     //    'The catalog $newCatalog does not have one of $_itemIds in it.');
//     _school = newSchool;
//     //_classes = [];
//     //_teachers = [];
//     //notifyListeners();
//   }

//   List<Class> get classes {
//     return _classes.toList();
//   }

//   List<Teacher> get teachers {
//     return _teachers.toList();
//   }

//   Class findClassById(String id) {
//     return _classes.firstWhere((i) => i.id == id);
//   }

//   Future<void> fetchAndSetClasses() async {
//     final List<Class> loaded = [];
//     try {
//       final snapshot = await db
//           .collection(School.tableName)
//           .doc(school.id)
//           .collection(Class.tableName)
//           .get();
//       if (snapshot.size == 0) {
//         _classes = loaded;
//         return;
//       }

//       print("fetchAndSetClasss");

//       snapshot.docs.forEach((doc) async {
//         loaded.add(Class(
//           id: doc.id,
//           name: doc.get('name'),
//           grade: doc.get('grade'),
//           classTeacher: Teacher(
//             userId: doc.get('classTeacher')['userId'],
//             name: doc.get('classTeacher')['name'],
//             imageURL: doc.get('classTeacher')['imageURL'],
//           ),
//         )

//             //teacherId: doc.get('teacherId'),

//             );
//       });

//       _classes = loaded;
//       notifyListeners();
//     } catch (e) {
//       print(e.toString());
//       throw (e);
//     }
//   }

//   Future<void> addClass(Class item) async {
//     final newItem = {
//       'name': item.name,
//       'grade': item.grade,
//       'classTeacher': {
//         'userId': item.classTeacher.userId,
//         'name': item.classTeacher.name,
//         'imageURL': item.classTeacher.imageURL,
//       }
//     };

//     print('classTeacher name : ' + item.classTeacher.name);
//     print('classTeacher image : ' + item.classTeacher.imageURL);

//     try {
//       final classCollection = db
//           .collection(School.tableName)
//           .doc(_school.id)
//           .collection(Class.tableName);

//       final addedItem = await classCollection.add(newItem);

//       final newItemList = Class(
//         id: addedItem.id,
//         name: item.name,
//         grade: item.grade,
//         classTeacher: item.classTeacher,
//       );

//       _classes.insert(0, newItemList);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> updateClass(String id, Class newItem) async {
//     final itemIndex = _classes.indexWhere((item) => item.id == id);
//     if (itemIndex >= 0) {
//       try {
//         await db
//             .collection(School.tableName)
//             .doc(_school.id)
//             .collection(Class.tableName)
//             .doc(id)
//             .update({
//           'name': newItem.name,
//           'grade': newItem.grade,
//           'classTeacher': {
//             'userId': newItem.classTeacher.userId,
//             'name': newItem.classTeacher.name,
//             'imageURL': newItem.classTeacher.imageURL,
//           }
//         });
//         _classes[itemIndex] = newItem;
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such item with id : ' + id);
//     }
//   }

//   Future<void> deleteClass(String id) async {
//     final existingItemIndex = _classes.indexWhere((i) => i.id == id);
//     var existingItem = _classes[existingItemIndex];
//     _classes.removeAt(existingItemIndex);
//     notifyListeners();

//     try {
//       await db
//           .collection(School.tableName)
//           .doc(_school.id)
//           .collection(Class.tableName)
//           .doc(id)
//           .delete();
//       existingItem = null;
//     } catch (e) {
//       _classes.insert(existingItemIndex, existingItem);
//       notifyListeners();
//       throw e;
//     }
//   }

//   Teacher findTeacherById(String userId) {
//     return _teachers.firstWhere((i) => i.userId == userId);
//   }

//   List<Teacher> findTeachersByNamePattern(String pattern) {
//     return _teachers
//         .where((s) => s.name.toLowerCase().contains(pattern.toLowerCase()))
//         .toList();
//   }

//   Future<void> fetchAndSetTeachers() async {
//     final List<Teacher> loaded = [];
//     try {
//       final snapshot = await db
//           .collection(School.tableName)
//           .doc(_school.id)
//           .collection(Teacher.tableName)
//           .get();

//       if (snapshot.size == 0) {
//         _teachers = loaded;
//         print("fetchAndSetTeachers : No teachers to display");
//         return;
//       }
//       print("fetchAndSetTeachers");
//       snapshot.docs.forEach((doc) async {
//         loaded.add(
//           Teacher(
//             userId: doc.id,
//             name: doc.get('name'),
//             imageURL:
//                 doc.data().containsKey('imageURL') ? doc.get('imageURL') : "",
//           ),
//         );
//       });

//       _teachers = loaded;
//       notifyListeners();
//     } catch (e) {
//       print(e.toString());
//       throw (e);
//     }
//   }

//   Future<void> addTeacher(Member addedUser) async {
//     final newItem = {
//       'userId': addedUser.id,
//       'name': addedUser.username,
//       'imageURL': addedUser.imageURL,
//     };

//     try {
//       final schoolCollection = db.collection(School.tableName).doc(_school.id);

//       // adding to School => teachers collection
//       await schoolCollection
//           .collection(Teacher.tableName)
//           .doc(addedUser.id)
//           .set(newItem);
//       // updating to School  collection
//       await schoolCollection.update({
//         'teachers': FieldValue.arrayUnion([addedUser.id]),
//       });

//       print('User ' + addedUser.username + ' user added as Teacher');

//       final newItemList = Teacher(
//         userId: addedUser.id,
//         name: addedUser.username,
//         imageURL: addedUser.imageURL,
//       );

//       _teachers.insert(0, newItemList);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> updateTeacher(String userId, Teacher newItem) async {
//     final itemIndex = _teachers.indexWhere((item) => item.userId == userId);
//     if (itemIndex >= 0) {
//       try {
//         await db
//             .collection(School.tableName)
//             .doc(_school.id)
//             .collection(Teacher.tableName)
//             .doc(userId)
//             .update({
//           'userId': newItem.userId,
//         });
//         _teachers[itemIndex] = newItem;
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such item with userId : ' + userId);
//     }
//   }

//   Future<void> deleteTeacher(String userId) async {
//     final existingItemIndex = _teachers.indexWhere((i) => i.userId == userId);
//     var existingItem = _teachers[existingItemIndex];
//     _teachers.removeAt(existingItemIndex);
//     notifyListeners();

//     try {
//       // removing from school => teachers collections
//       await db
//           .collection(School.tableName)
//           .doc(_school.id)
//           .collection(Teacher.tableName)
//           .doc(userId)
//           .delete();
//       existingItem = null;

//       // updating the school collection
//       await db.collection(School.tableName).doc(_school.id).update({
//         'teachers': FieldValue.arrayRemove([userId])
//       });
//     } catch (e) {
//       _teachers.insert(existingItemIndex, existingItem);
//       notifyListeners();
//       throw e;
//     }
//   }
// }
