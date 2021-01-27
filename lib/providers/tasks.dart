import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/task.dart';
import '../data/constants.dart';

class Tasks with ChangeNotifier {
  final taskTable = tables['tasks'];
  final chapterTable = tables['chapters'];
  final classesTable = tables['classes'];

  final db = FirebaseFirestore.instance;

  List<Task> _items = [];

  List<Task> get items {
    return _items.toList();
  }

  Task findById(String id) {
    return _items.firstWhere((i) => i.id == id);
  }

  Future<void> fetchAndSet() async {
    final List<Task> loaded = [];
    try {
      final snapshot = await db.collection(taskTable).get();
      if (snapshot.size == 0) return;

      print("fetchAndSetTasks");

      snapshot.docs.forEach((doc) async {
        loaded.add(
          Task(
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

  Future<void> add(Task item) async {
    final newItem = {
      'name': item.name,
      'createdById': item.createdById,
      'assignedToId': item.assignedToId,
    };

    try {
      final taskCollection = FirebaseFirestore.instance.collection(taskTable);

      final addedItem = await taskCollection.add(newItem);

      final newItemList = Task(
        id: addedItem.id,
        name: item.name,
        createdById: item.createdById,
        assignedToId: item.assignedToId,
      );

      _items.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> update(String id, Task newItem) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      try {
        await FirebaseFirestore.instance.collection(taskTable).doc(id).update({
          'name': newItem.name,
          'createdById': newItem.createdById,
          'assignedToId': newItem.assignedToId,
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
      await FirebaseFirestore.instance.collection(taskTable).doc(id).delete();
      existingItem = null;
    } catch (e) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }
}
