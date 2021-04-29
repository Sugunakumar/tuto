import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuto/models/models.dart';

class Class with ChangeNotifier {
  static final String tableName = 'classes';
  final String id;
  final String name;
  final String grade;

  final Teacher classTeacher;
  List<Book> books;

  Class({
    @required this.id,
    @required this.name,
    @required this.grade,
    this.classTeacher,
  });
}

// class ClassModel with ChangeNotifier {
//   final db = FirebaseFirestore.instance;

//   //List<Class> _classes = [];

//   School _school;

//   School get school => _school;

//   set school(School newSchool) {
//     assert(newSchool != null);
//     _school = newSchool;
//     notifyListeners();
//   }

//   List<Class> get classes {
//     return _school != null ? _school.classes.toList() : [];
//   }

//   Class findClassById(String id) {
//     return _school.classes.firstWhere((i) => i.id == id);
//   }

//   Future<void> fetchAndSetClasses(School school) async {
//     _school = school;
//     final List<Class> loaded = [];
//     try {
//       final snapshot = await db
//           .collection(School.tableName)
//           .doc(_school.id)
//           .collection(Class.tableName)
//           .get();
//       if (snapshot.size == 0) {
//         //_classes = loaded;
//         _school.classes = loaded;
//         return;
//       }

//       print("fetchAndSetClasss");

//       snapshot.docs.forEach((doc) async {
//         loaded.add(Class(
//           id: doc.id,
//           name: doc.get('name'),
//           grade: doc.get('grade'),

//           // classTeacher: Teacher(
//           //   user: CurrentUser(id:  doc.get('classTeacher')['userId'], email: null, username: null, imageURL: null),
//           //   userId:,
//           //   name: doc.get('classTeacher')['name'],
//           //   imageURL: doc.get('classTeacher')['imageURL'],
//           // ),
//         )

//             //teacherId: doc.get('teacherId'),

//             );
//       });

//       // _classes = loaded;
//       _school.classes = loaded;
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
//       // 'classTeacher': {
//       //   'userId': item.classTeacher.userId,
//       //   'name': item.classTeacher.name,
//       //   'imageURL': item.classTeacher.imageURL,
//       // }
//     };

//     //print('classTeacher name : ' + item.classTeacher.name);
//     //print('classTeacher image : ' + item.classTeacher.imageURL);

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

//       //_classes.insert(0, newItemList);
//       _school.classes.insert(0, newItemList);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> updateClass(String id, Class newItem) async {
//     //final itemIndex = _classes.indexWhere((item) => item.id == id);
//     final itemIndex = _school.classes.indexWhere((item) => item.id == id);
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
//           // 'classTeacher': {
//           //   'userId': newItem.classTeacher.userId,
//           //   'name': newItem.classTeacher.name,
//           //   'imageURL': newItem.classTeacher.imageURL,
//           // }
//         });
//         //_classes[itemIndex] = newItem;
//         _school.classes[itemIndex] = newItem;
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
//     final _classes = _school.classes;
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
// }
