import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tuto/data/constants.dart';

import 'package:tuto/models/admin.dart';
import 'package:tuto/models/task.dart';
import 'package:tuto/models/teacher.dart';
import './class.dart';

final db = FirebaseFirestore.instance;
final schoolTable = tables['schools'];

class School with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String board;
  final String imageURL;
  final Role role;

  String get schoolId => id;

  List<Class> classes = [];
  List<Task> tasks = [];
  List<Teacher> teachers = [];
  List<Admin> admin = [];

  School({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.board,
    @required this.imageURL,
    this.email,
    this.phone,
    this.role = Role.Individual,
  });
}

//   Future<void> addTeacher(CurrentUser user) async {
//     Teacher newItem = Teacher(
//       name: user.username,
//       userId: user.id,
//       imageURL: user.imageURL,
//     );
//     teachers.add(newItem);
//     notifyListeners();
//     try {
//       await FirebaseFirestore.instance.collection(schoolTable).doc(id).update({
//         'teachers': FieldValue.arrayUnion([user.id]),
//       });
//     } catch (e) {
//       teachers.remove(newItem);
//       print(e);
//       throw e;
//     }
//   }

//   Future<void> removeTeacher(CurrentUser user) async {
//     final existingItemIndex =
//         teachers.indexWhere((item) => item.userId == user.id);
//     var existingItem = teachers[existingItemIndex];
//     teachers.removeAt(existingItemIndex);
//     notifyListeners();

//     try {
//       await FirebaseFirestore.instance.collection(schoolTable).doc(id).update({
//         'teachers': FieldValue.arrayRemove([user.id]),
//       });
//       existingItem = null;
//     } catch (e) {
//       teachers.insert(existingItemIndex, existingItem);
//       notifyListeners();
//       throw e;
//     }
//   }
// }

// Future<void> fetchAndSetAll() async {
//   await fetchAndSetclasses();
//   await fetchAndSetTeachers();
//   await fetchAndSetTasks();
// }

// Future<void> fetchAndSetTasks() async {
//   final List<Task> loaded = [];
//   try {
//     final snapshot = await db
//         .collection(tables['schools'])
//         .doc(id)
//         .collection(tables['tasks'])
//         .get();
//     if (snapshot.size == 0) return;
//     print("fetch and set tasks");

//     snapshot.docs.forEach((doc) async {
//       loaded.add(
//         Task(
//           id: doc.id,
//           name: doc.get('name'),
//           createdById: doc.get('createdById'),
//           assignedToId: doc.get('assignedToId'),
//         ),
//       );
//     });

//     this.tasks = loaded;

//     notifyListeners();
//   } catch (e) {
//     throw (e);
//   }
// }

// Future<void> fetchAndSetTeachers() async {
//   final List<Teacher> loaded = [];
//   try {
//     final snapshot = await db
//         .collection(tables['schools'])
//         .doc(id)
//         .collection(tables['teachers'])
//         .get();
//     if (snapshot.size == 0) return;
//     print("fetch and set teachers");

//     snapshot.docs.forEach((doc) async {
//       loaded.add(
//         Teacher(
//           userId: doc.id,
//           name: doc.get('name'),
//           imageURL: doc.get('imageURL'),
//         ),
//       );
//     });

//     this.teachers = loaded;

//     notifyListeners();
//   } catch (e) {
//     throw (e);
//   }
// }

// Future<void> fetchAndSetclasses() async {
//   final List<Class> loaded = [];
//   try {
//     final snapshot = await db
//         .collection(tables['schools'])
//         .doc(id)
//         .collection(tables['classes'])
//         .get();
//     if (snapshot.size == 0) return;
//     print("fetch and set classes");

//     snapshot.docs.forEach((doc) async {
//       loaded.add(
//         Class(
//           id: doc.id,
//           name: doc.get('name'),
//           grade: doc.get('classTeacher'),
//         ),
//       );
//     });

//     this.classes = loaded;

//     notifyListeners();
//   } catch (e) {
//     throw (e);
//   }
// }
// }
