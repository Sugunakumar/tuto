import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/subject.dart';
import '../data/constants.dart';

class Subjects with ChangeNotifier {
  final subjectTable = tables['subjects'];
  final chapterTable = tables['chapters'];
  final classesTable = tables['classes'];

  final db = FirebaseFirestore.instance;

  List<Subject> _items = [];

  String _classId;

  String get classId => _classId;

  set classId(String id) {
    this._classId = id;
  }

  List<Subject> get items {
    return _items.toList();
  }

  Subject findById(String id) {
    return _items.firstWhere((i) => i.id == id);
  }

  Future<void> fetchAndSet(String classId) async {
    this._classId = classId;
    final List<Subject> loaded = [];
    try {
      final snapshot = await db.collection(subjectTable).get();
      if (snapshot.size == 0) return;

      print("fetchAndSetSubjects");

      snapshot.docs.forEach((doc) async {
        loaded.add(
          Subject(
            id: doc.id,
            name: doc.get('name'),
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

  Future<void> add(Subject item) async {
    final newItem = {
      'name': item.name,
    };

    try {
      final subjectCollection =
          FirebaseFirestore.instance.collection(subjectTable);

      final addedItem = await subjectCollection.add(newItem);

      final newItemList = Subject(
        id: addedItem.id,
        name: item.name,
      );

      _items.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> update(String id, Subject newItem) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(subjectTable)
            .doc(id)
            .update({
          'name': newItem.name,
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
      await FirebaseFirestore.instance
          .collection(subjectTable)
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
