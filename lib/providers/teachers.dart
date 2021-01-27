import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/models/user.dart';

import '../models/teacher.dart';
import '../data/constants.dart';

class Teachers with ChangeNotifier {
  final teacherTable = tables['teachers'];
  final schoolsTable = tables['schools'];

  final db = FirebaseFirestore.instance;

  List<Teacher> _items = [];

  List<Teacher> get items {
    return _items.toList();
  }

  String _schoolId;

  //String get schoolId => _schoolId;

  Teacher findById(String userId) {
    return _items.firstWhere((i) => i.userId == userId);
  }

  List<Teacher> findByName(String pattern) {
    return _items
        .where((s) => s.name.toLowerCase().contains(pattern.toLowerCase()))
        .toList();
  }

  Future<void> fetchAndSet(String schoolId) async {
    this._schoolId = schoolId;
    final List<Teacher> loaded = [];
    try {
      final snapshot = await db
          .collection(schoolsTable)
          .doc(schoolId)
          .collection(teacherTable)
          .get();

      if (snapshot.size == 0) {
        _items = loaded;
        print("fetchAndSetTeachers : No teachers to display");
        return;
      }
      print("fetchAndSetTeachers");
      snapshot.docs.forEach((doc) async {
        loaded.add(
          Teacher(
            userId: doc.id,
            name: doc.get('name'),
            imageURL:
                doc.data().containsKey('imageURL') ? doc.get('imageURL') : "",
          ),
        );
      });

      _items = loaded;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> add(CurrentUser addedUser) async {
    final newItem = {
      'userId': addedUser.id,
      'name': addedUser.username,
      'imageURL': addedUser.imageURL,
    };

    try {
      final schoolCollection = db.collection(schoolsTable).doc(_schoolId);

      // adding to School => teachers collection
      await schoolCollection
          .collection(teacherTable)
          .doc(addedUser.id)
          .set(newItem);
      // updating to School  collection
      await schoolCollection.update({
        'teachers': FieldValue.arrayUnion([addedUser.id]),
      });

      print('User ' + addedUser.username + ' user added as Teacher');

      final newItemList = Teacher(
        userId: addedUser.id,
        name: addedUser.username,
        imageURL: addedUser.imageURL,
      );

      _items.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> update(String userId, Teacher newItem) async {
    final itemIndex = _items.indexWhere((item) => item.userId == userId);
    if (itemIndex >= 0) {
      try {
        await db
            .collection(schoolsTable)
            .doc(_schoolId)
            .collection(teacherTable)
            .doc(userId)
            .update({
          'userId': newItem.userId,
        });
        _items[itemIndex] = newItem;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('No such item with userId : ' + userId);
    }
  }

  Future<void> delete(String userId) async {
    final existingItemIndex = _items.indexWhere((i) => i.userId == userId);
    var existingItem = _items[existingItemIndex];
    _items.removeAt(existingItemIndex);
    notifyListeners();

    try {
      // removing from school => teachers collections
      await db
          .collection(schoolsTable)
          .doc(_schoolId)
          .collection(teacherTable)
          .doc(userId)
          .delete();
      existingItem = null;

      // updating the school collection
      await db.collection(schoolsTable).doc(_schoolId).update({
        'teachers': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }
}
