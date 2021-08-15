import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskStatus { NotStarted, InProgress, Completed }

class Task with ChangeNotifier {
  // School _school;

  // set school(School newSchool) {
  //   assert(newSchool != null);
  //   _school = newSchool;
  //   notifyListeners();
  // }

  // School get school => _school;

  // final db = FirebaseFirestore.instance;

  // //List<String> belongsToTask;
  // String classTeacherForTask;
  // List<Task> _tasks = [];

  // List<Task> get classes {
  //   return _tasks.toList();
  // }

  // Task findTaskById(String id) {
  //   return _tasks.firstWhere((i) => i.id == id);
  // }

  // Future<void> fetchAndSetTasks() async {
  //   final List<Task> loaded = [];
  //   try {
  //     final snapshot = await db
  //         .collection(schoolsTableName)
  //         .doc(_school.id)
  //         .collection(classesTableName)
  //         .get();
  //     if (snapshot.size == 0) {
  //       _tasks = loaded;
  //       return;
  //     }

  //     print("fetchAndSetTasks");

  //     snapshot.docs.forEach((doc) async {
  //       loaded.add(Task(
  //         schoolId: _school.id,
  //         id: doc.id,
  //         name: doc.get('name'),
  //         grade: doc.get('grade'),

  //         // classTeacher: Teacher(
  //         //   user: CurrentUser(id:  doc.get('classTeacher')['userId'], email: null, username: null, imageURL: null),
  //         //   userId:,
  //         //   name: doc.get('classTeacher')['name'],
  //         //   imageURL: doc.get('classTeacher')['imageURL'],
  //         // ),
  //       )

  //           //teacherId: doc.get('teacherId'),

  //           );
  //     });

  //     _tasks = loaded;
  //     notifyListeners();
  //   } catch (e) {
  //     print(e.toString());
  //     throw (e);
  //   }
  // }

  // Future<void> addTask(Task item) async {
  //   final newItem = {
  //     'name': item.name,
  //     'grade': item.grade,
  //     // 'classTeacher': {
  //     //   'userId': item.classTeacher.userId,
  //     //   'name': item.classTeacher.name,
  //     //   'imageURL': item.classTeacher.imageURL,
  //     // }
  //   };

  //   //print('classTeacher name : ' + item.classTeacher.name);
  //   //print('classTeacher image : ' + item.classTeacher.imageURL);

  //   try {
  //     final classCollection = db
  //         .collection(schoolsTableName)
  //         .doc(_school.id)
  //         .collection(classesTableName);

  //     final addedItem = await classCollection.add(newItem);

  //     final newItemList = Task(
  //       id: addedItem.id,
  //       name: item.name,
  //       grade: item.grade,
  //       classTeacher: item.classTeacher,
  //     );

  //     _tasks.insert(0, newItemList);

  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     throw e;
  //   }
  // }

  // Future<void> updateTask(String id, Task newItem) async {
  //   final itemIndex = _tasks.indexWhere((item) => item.id == id);

  //   if (itemIndex >= 0) {
  //     try {
  //       await db
  //           .collection(schoolsTableName)
  //           .doc(_school.id)
  //           .collection(classesTableName)
  //           .doc(id)
  //           .update({
  //         'name': newItem.name,
  //         'grade': newItem.grade,
  //         // 'classTeacher': {
  //         //   'userId': newItem.classTeacher.userId,
  //         //   'name': newItem.classTeacher.name,
  //         //   'imageURL': newItem.classTeacher.imageURL,
  //         // }
  //       });
  //       _tasks[itemIndex] = newItem;

  //       notifyListeners();
  //     } catch (e) {
  //       print(e);
  //       throw e;
  //     }
  //   } else {
  //     print('No such item with id : ' + id);
  //   }
  // }

  // Future<void> deleteTask(String id) async {
  //   final existingItemIndex = _tasks.indexWhere((i) => i.id == id);
  //   var existingItem = _tasks[existingItemIndex];
  //   _tasks.removeAt(existingItemIndex);
  //   notifyListeners();

  //   try {
  //     await db
  //         .collection(schoolsTableName)
  //         .doc(id)
  //         .collection(classesTableName)
  //         .doc(id)
  //         .delete();
  //     existingItem = null;
  //   } catch (e) {
  //     _tasks.insert(existingItemIndex, existingItem);
  //     notifyListeners();
  //     throw e;
  //   }
  // }
}
