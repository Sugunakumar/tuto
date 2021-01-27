import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/models/class.dart';
import 'package:tuto/models/school.dart';
import 'package:tuto/models/teacher.dart';
import '../data/constants.dart';

class Classes with ChangeNotifier {
  final classesTable = tables['classes'];
  final schoolsTable = tables['schools'];

  //final String schoolId;

  //Classes(this.schoolId);

  final db = FirebaseFirestore.instance;

  List<Class> _items = [];

  String _schoolId;

  String get schoolId => _schoolId;

  set schoolId(String id) {
    this._schoolId = id;
  }

  List<Class> get items {
    return _items.toList();
  }

  Class findById(String id) {
    return _items.firstWhere((i) => i.id == id);
  }

  Future<void> fetchAndSet() async {
    final List<Class> loaded = [];
    try {
      final snapshot = await db
          .collection(schoolsTable)
          .doc(schoolId)
          .collection(classesTable)
          .get();
      if (snapshot.size == 0) {
        _items = loaded;
        return;
      }

      print("fetchAndSetClasss");

      snapshot.docs.forEach((doc) async {
        loaded.add(Class(
          id: doc.id,
          name: doc.get('name'),
          grade: doc.get('grade'),
          classTeacher: Teacher(
            userId: doc.get('classTeacher')['userId'],
            name: doc.get('classTeacher')['name'],
            imageURL: doc.get('classTeacher')['imageURL'],
          ),
        )

            //teacherId: doc.get('teacherId'),

            );
      });

      _items = loaded;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> add(Class item) async {
    final newItem = {
      'name': item.name,
      'grade': item.grade,
      'classTeacher': {
        'userId': item.classTeacher.userId,
        'name': item.classTeacher.name,
        'imageURL': item.classTeacher.imageURL,
      }
    };

    print('classTeacher name : ' + item.classTeacher.name);
    print('classTeacher image : ' + item.classTeacher.imageURL);

    try {
      final classCollection =
          db.collection(schoolsTable).doc(_schoolId).collection(classesTable);

      final addedItem = await classCollection.add(newItem);

      final newItemList = Class(
        id: addedItem.id,
        name: item.name,
        grade: item.grade,
        classTeacher: item.classTeacher,
      );

      _items.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> update(String id, Class newItem) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      try {
        await db
            .collection(schoolsTable)
            .doc(_schoolId)
            .collection(classesTable)
            .doc(id)
            .update({
          'name': newItem.name,
          'grade': newItem.grade,
          'classTeacher': {
            'userId': newItem.classTeacher.userId,
            'name': newItem.classTeacher.name,
            'imageURL': newItem.classTeacher.imageURL,
          }
        });
        _items[itemIndex] = newItem;
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
    final existingItemIndex = _items.indexWhere((i) => i.id == id);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();

    try {
      await db
          .collection(schoolsTable)
          .doc(_schoolId)
          .collection(classesTable)
          .doc(id)
          .delete();
      existingItem = null;
    } catch (e) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }
}
