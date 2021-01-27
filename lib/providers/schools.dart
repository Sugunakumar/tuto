import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/school.dart';
import '../data/constants.dart';

class Schools with ChangeNotifier {
  final schoolTable = tables['schools'];
  final chapterTable = tables['chapters'];
  final classesTable = tables['classes'];

  final db = FirebaseFirestore.instance;

  List<School> _items = [];

  List<School> get items {
    return _items.toList();
  }

  School findById(String id) {
    return _items.firstWhere((i) => i.id == id);
  }

  Future<void> fetchAndSet() async {
    final List<School> loaded = [];
    try {
      final snapshot = await db.collection(schoolTable).get();
      if (snapshot.size == 0) {
        print("fetchAndSetSchools : No schools to display");
        _items = loaded;
        return;
      }

      print("fetchAndSetSchools");

      snapshot.docs.forEach((doc) async {
        List<dynamic> students =
            doc.data().containsKey('students') ? doc.get('students') : null;
        List<dynamic> teachers =
            doc.data().containsKey('teachers') ? doc.get('teachers') : null;
        List<dynamic> admins =
            doc.data().containsKey('admins') ? doc.get('admins') : null;

        bool isStudent = students == null
            ? false
            : students.contains(FirebaseAuth.instance.currentUser.uid)
                ? true
                : false;
        bool isTeacher = teachers == null
            ? false
            : teachers.contains(FirebaseAuth.instance.currentUser.uid)
                ? true
                : false;
        bool isAdmin = admins == null
            ? false
            : admins.contains(FirebaseAuth.instance.currentUser.uid)
                ? true
                : false;

        loaded.add(
          School(
              id: doc.id,
              name: doc.get('name'),
              address: doc.get('address'),
              board: doc.get('board'),
              imageURL: doc.get('imageURL'),
              email: doc.data().containsKey('email') ? doc.get('email') : null,
              phone: doc.data().containsKey('phone') ? doc.get('phone') : null,
              role: isAdmin
                  ? Role.Admin
                  : isTeacher
                      ? Role.Teacher
                      : isStudent ? Role.Student : Role.Individual),
        );
      });

      _items = loaded;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> add(School item, File image) async {
    final newItem = {
      'name': item.name,
      'address': item.address,
      'board': item.board,
      'imageURL': item.imageURL,
      'email': item.email,
      'phone': item.phone,
    };

    try {
      final schoolCollection =
          FirebaseFirestore.instance.collection(schoolTable);

      final addedItem = await schoolCollection.add(newItem);

      var imageUrl;

      if (image != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('school_images')
            .child(addedItem.id + '.jpg');

        await ref.putFile(image).onComplete;

        imageUrl = await ref.getDownloadURL();
      }

      if (imageUrl != null) {
        await schoolCollection.doc(addedItem.id).update({'imageURL': imageUrl});
      }

      final newItemList = School(
          id: addedItem.id,
          name: item.name,
          address: item.address,
          board: item.board,
          imageURL: item.imageURL,
          email: item.email,
          phone: item.phone);

      _items.insert(0, newItemList);

      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> update(String id, School newItem) async {
    final itemIndex = _items.indexWhere((item) => item.id == id);
    if (itemIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(schoolTable)
            .doc(id)
            .update({
          'name': newItem.name,
          'address': newItem.address,
          'board': newItem.board,
          'imageURL': newItem.imageURL,
          'email': newItem.email,
          'phone': newItem.phone,
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
      await FirebaseFirestore.instance.collection(schoolTable).doc(id).delete();
      existingItem = null;
    } catch (e) {
      _items.insert(existingItemIndex, existingItem);
      notifyListeners();
      throw e;
    }
  }
}
