import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/models/models.dart';

import '../data/constants.dart';

// class ClassProvider with ChangeNotifier {
//   final schoolsTable = tables['schools'];
//   final studentTable = tables['students'];
//   final chapterTable = tables['chapters'];
//   final classesTable = tables['classes'];
//   final subjectTable = tables['subjects'];

//   final db = FirebaseFirestore.instance;

//   List<Book> _subjects = [];
//   List<Student> _students = [];
//   List<Book> _books = [];

//   Class _clazz;
//   School _school;

//   Class get clazz => _clazz;
//   School get school => _school;

//   set clazz(Class loadedClass) {
//     assert(loadedClass != null);
//     this._clazz = loadedClass;
//     _subjects = [];
//     _students = [];
//     _books = [];
//     //notifyListeners();
//   }

//   set schoolProvider(SchoolProvider schoolProvider) {
//     assert(schoolProvider != null);
//     _school = schoolProvider.school;
//     notifyListeners();
//   }

//   List<Book> get subjects {
//     return _subjects.toList();
//   }

//   List<Student> get students {
//     return _students.toList();
//   }

//   List<Book> get books {
//     return _books.toList();
//   }

//   Book findBookById(String id) {
//     return _subjects.firstWhere((i) => i.id == id);
//   }

//   Future<void> fetchAndSetBooks() async {
//     final List<Book> loaded = [];
//     try {
//       final snapshot = await db.collection(subjectTable).get();
//       if (snapshot.size == 0) return;

//       print("fetchAndSetBooks");

//       snapshot.docs.forEach((doc) async {
//         loaded.add(
//           Book(
//             id: doc.id,
//             name: doc.get('name'),
//           ),
//         );
//       });

//       _subjects = loaded;
//       notifyListeners();
//     } catch (e) {
//       print(e.toString());
//       throw (e);
//     }
//   }

//   Future<void> addBook(Book item) async {
//     final newItem = {
//       'name': item.name,
//     };

//     try {
//       final subjectCollection =
//           FirebaseFirestore.instance.collection(subjectTable);

//       final addedItem = await subjectCollection.add(newItem);

//       final newItemList = Book(
//         id: addedItem.id,
//         name: item.name,
//       );

//       _subjects.insert(0, newItemList);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> updateBook(String id, Book newItem) async {
//     final itemIndex = _subjects.indexWhere((item) => item.id == id);
//     if (itemIndex >= 0) {
//       try {
//         await FirebaseFirestore.instance
//             .collection(subjectTable)
//             .doc(id)
//             .update({
//           'name': newItem.name,
//         });
//         _subjects[itemIndex] = newItem;
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such item with id : ' + id);
//     }
//   }

//   Future<void> deleteBook(String id) async {
//     final existingItemIndex = _subjects.indexWhere((i) => i.id == id);
//     var existingItem = _subjects[existingItemIndex];
//     _subjects.removeAt(existingItemIndex);
//     notifyListeners();

//     try {
//       await FirebaseFirestore.instance
//           .collection(subjectTable)
//           .doc(id)
//           .delete();
//       existingItem = null;
//     } catch (e) {
//       _subjects.insert(existingItemIndex, existingItem);
//       notifyListeners();
//       throw e;
//     }
//   }

//   Book findBookById(String id) {
//     return _books.firstWhere((i) => i.id == id);
//   }

//   Future<void> fetchAndSetBooks() async {
//     print("fetchAndSetFilteredBooks");
//     final List<Book> loaded = [];
//     try {
//       final classDoc = await db
//           .collection(School.tableName)
//           .doc(_school.id)
//           .collection(Class.tableName)
//           .doc(_clazz.id)
//           .get();

//       List<String> bookIds = List.from(classDoc.get('books'));
//       print('bookIds : ' + bookIds.toString());

//       for (var bookId in bookIds) {
//         print('bookId : ' + bookId);
//       }

//       final snapshot = await db
//           .collection(Book.tableName)
//           .where(FieldPath.documentId, whereIn: bookIds)
//           .get();

//       if (snapshot.size == 0) {
//         _books = loaded;
//         print("fetchAndSetFilteredBooks : No books to display");
//         return;
//       }

//       snapshot.docs.forEach((doc) async {
//         loaded.add(
//           Book(
//             id: doc.id,
//             grade: doc.get('grade'),
//             subject: doc.get('subject'),
//             title: doc.get('title'),
//             description: doc.get('description'),
//             pages: doc.get('pages'),
//             editor: doc.get('editor'),
//             publisher: doc.get('publisher'),
//             imageUrl: doc.get('imageUrl'),
//           ),
//         );
//       });
//       _books = loaded;
//       print("_books : " + _books.length.toString());

//       notifyListeners();
//     } catch (e) {
//       print(e.toString());
//       throw (e);
//     }
//   }

//   Future<void> addBook(Book item) async {
//     final newItem = {
//       'name': item.name,
//     };

//     try {
//       final subjectCollection =
//           FirebaseFirestore.instance.collection(subjectTable);

//       final addedItem = await subjectCollection.add(newItem);

//       final newItemList = Book(
//         id: addedItem.id,
//         name: item.name,
//       );

//       _subjects.insert(0, newItemList);

//       notifyListeners();
//     } catch (e) {
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> updateBook(String id, Book newItem) async {
//     final itemIndex = _subjects.indexWhere((item) => item.id == id);
//     if (itemIndex >= 0) {
//       try {
//         await FirebaseFirestore.instance
//             .collection(subjectTable)
//             .doc(id)
//             .update({
//           'name': newItem.name,
//         });
//         _subjects[itemIndex] = newItem;
//         notifyListeners();
//       } catch (e) {
//         print(e);
//         throw e;
//       }
//     } else {
//       print('No such item with id : ' + id);
//     }
//   }

//   Future<void> deleteBook(String id) async {
//     final existingItemIndex = _subjects.indexWhere((i) => i.id == id);
//     var existingItem = _subjects[existingItemIndex];
//     _subjects.removeAt(existingItemIndex);
//     notifyListeners();

//     try {
//       await FirebaseFirestore.instance
//           .collection(subjectTable)
//           .doc(id)
//           .delete();
//       existingItem = null;
//     } catch (e) {
//       _subjects.insert(existingItemIndex, existingItem);
//       notifyListeners();
//       throw e;
//     }
//   }

//   Student findStudentById(String userId) {
//     return _students.firstWhere((i) => i.userId == userId);
//   }

//   Future<void> fetchAndSetStudents() async {
//     final List<Student> loaded = [];
//     try {
//       final snapshot = await db
//           .collection(schoolsTable)
//           .doc(_school.id)
//           .collection(classesTable)
//           .doc(_clazz.id)
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

//   Future<void> addStudent(Member addedUser) async {
//     final newItem = {
//       'userId': addedUser.id,
//       'name': addedUser.username,
//       'imageURL': addedUser.imageURL,
//     };

//     try {
//       final classCollection = db
//           .collection(schoolsTable)
//           .doc(_school.id)
//           .collection(classesTable)
//           .doc(_clazz.id);

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
//             .doc(_school.id)
//             .collection(classesTable)
//             .doc(_clazz.id)
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
//           .doc(_school.id)
//           .collection(classesTable)
//           .doc(_clazz.id)
//           .collection(studentTable)
//           .doc(userId)
//           .delete();
//       existingItem = null;
//       // updating the school collection
//       await db
//           .collection(schoolsTable)
//           .doc(_school.id)
//           .collection(classesTable)
//           .doc(_clazz.id)
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
