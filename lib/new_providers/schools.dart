import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:path/path.dart" as path;
import "package:path_provider/path_provider.dart" as syspaths;

import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/models.dart';

class Schools with ChangeNotifier {
  final db = FirebaseFirestore.instance;

  List<School> _items = [];

  List<School> get items {
    return _items.toList();
  }

  List<School> findSchoolsByName(String searchText) {
    if (searchText.isEmpty) {
      return _items.toList();
    }
    return _items
        .where((s) => s.name.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  School findById(String id) {
    return _items.firstWhere((i) => i.id == id);
  }

  bool isTeacher(String schoolId, String userId) {
    return findById(schoolId).teacherIds.contains(userId);
  }

  bool isStudent(String schoolId, String userId) {
    School school = findById(schoolId);
    print('school : ' + school.name);
    print('school.studentIds : ' + school.studentIds.toString());
    return findById(schoolId).studentIds.contains(userId);
  }

  Future<void> fetchAndSet() async {
    final List<School> loaded = [];
    try {
      final snapshot = await db.collection(schoolsTableName).get();
      if (snapshot.size == 0) {
        print("fetchAndSetSchools : No schools to display");
        _items = loaded;
        return;
      }

      print("fetchAndSetSchools");

      snapshot.docs.forEach((doc) async {
        // List<dynamic> students =
        //     doc.data().containsKey('students') ? doc.get('students') : null;
        // List<dynamic> teachers =
        //     doc.data().containsKey('teachers') ? doc.get('teachers') : null;
        // List<dynamic> admins =
        //     doc.data().containsKey('admins') ? doc.get('admins') : null;

        // bool isStudent = students == null
        //     ? false
        //     : students.contains(FirebaseAuth.instance.currentUser.uid)
        //         ? true
        //         : false;
        // bool isTeacher = teachers == null
        //     ? false
        //     : teachers.contains(FirebaseAuth.instance.currentUser.uid)
        //         ? true
        //         : false;
        // bool isAdmin = admins == null
        //     ? false
        //     : admins.contains(FirebaseAuth.instance.currentUser.uid)
        //         ? true
        //         : false;

        loaded.add(
          School(
            id: doc.id,
            name: doc.get('name'),
            address: doc.get('address'),
            board: doc.get('board'),
            imageURL:
                doc.data().containsKey('imageURL') ? doc.get('imageURL') : null,
            email: doc.data().containsKey('email') ? doc.get('email') : null,
            phone: doc.data().containsKey('phone') ? doc.get('phone') : null,
            teacherIds: doc.data().containsKey('teachers')
                ? List.from(doc.get('teachers'))
                : [],
            studentIds: doc.data().containsKey('students')
                ? List.from(doc.get('students'))
                : [],
            adminIds: doc.data().containsKey('admins')
                ? List.from(doc.get('admins'))
                : [],
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

  Future<void> add(School item, File image) async {
    print('add school');
    final newItem = {
      'name': item.name,
      'address': item.address,
      'board': item.board,
      //'imageURL': item.imageURL,
      'email': item.email,
      'phone': item.phone,
    };

    try {
      final schoolCollection =
          FirebaseFirestore.instance.collection(schoolsTableName);

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
        imageURL: imageUrl,
        email: item.email,
        phone: item.phone,
        teacherIds: [],
        studentIds: [],
      );

      // final appDir = await syspaths.getApplicationDocumentsDirectory();
      // final savedImage =
      //     await image.copy('${appDir.path}/schools/${newItemList.id}');

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
            .collection(schoolsTableName)
            .doc(id)
            .update({
          'name': newItem.name,
          'address': newItem.address,
          'board': newItem.board,
          'imageURL': newItem.imageURL,
          'email': newItem.email,
          'phone': newItem.phone,
        });
        newItem.teacherIds = _items[itemIndex].teacherIds;
        newItem.studentIds = _items[itemIndex].studentIds;
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
          .collection(schoolsTableName)
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
