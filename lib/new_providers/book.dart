import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/models/models.dart';

import '../data/constants.dart';

final userTable = tables['users'];

class BookNotifier with ChangeNotifier {
  School _school;
  Class _class;
  Book _book;

  set school(School newSchool) {
    assert(newSchool != null);
    _school = newSchool;
    notifyListeners();
  }

  School get school => _school;

  set clazz(Class newClass) {
    assert(newClass != null);
    _class = newClass;
    notifyListeners();
  }

  Class get clazz => _class;

  set book(Book newBook) {
    assert(newBook != null);
    _book = newBook;
    notifyListeners();
  }

  Book get book => _book;

  List<Chapter> _chapters = [];

  // Future<void> toggleFavoriteStatus(String userId) async {
  //   final oldStatus = isFavorite;
  //   isFavorite = !isFavorite;
  //   print("toggleFavoriteStatus");
  //   notifyListeners();
  //   try {
  //     if (isFavorite)
  //       await FirebaseFirestore.instance
  //           .collection(userTable)
  //           .doc(userId)
  //           .update({
  //         'favorites': FieldValue.arrayUnion([id]),
  //       });
  //     else
  //       await FirebaseFirestore.instance
  //           .collection(userTable)
  //           .doc(userId)
  //           .update({
  //         'favorites': FieldValue.arrayRemove([id]),
  //       });
  //   } catch (e) {
  //     isFavorite = oldStatus;
  //     notifyListeners();
  //     print(e);
  //   }
  // }

  List<Chapter> get chapters {
    //return _chapters.toList();
    return _chapters.where((i) => i.bookId == _book.id).toList();
  }

  Chapter findChapterById(String id) {
    return _chapters.firstWhere((chap) => chap.id == id);
  }

  Future<void> fetchAndSetChapters() async {
    print("fetchAndSetChapters entry");
    final List<Chapter> loadedChapters = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(_book.id)
          .collection(chaptersTableName)
          .orderBy('index')
          .get();
      if (snapshot.size == 0) {
        _chapters = [];
        return;
      }
      snapshot.docs.forEach((doc) {
        loadedChapters.add(
          Chapter(
            bookId: _book.id,
            id: doc.id,
            index: doc.get('index'),
            title: doc.get('title'),
          ),
        );
        print(doc.get('title'));
        print(doc.id);
      });
      _chapters = loadedChapters;
      notifyListeners();
      print("fetchAndSetChapters exit");
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addChapter(Chapter chapter) async {
    final newChapter = {
      'index': chapter.index,
      'title': chapter.title,
    };

    try {
      final addedChapter = await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(_book.id)
          .collection(chaptersTableName)
          .add(newChapter);
      final newChapterList = Chapter(
        id: addedChapter.id,
        index: chapter.index,
        title: chapter.title,
      );
      _chapters.add(newChapterList);
      //_chapters.insert(0, newChapterList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateChapter(String id, Chapter newChapter) async {
    final prodIndex = _chapters.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(booksTableName)
            .doc(_book.id)
            .collection(chaptersTableName)
            .doc(id)
            .update({
          'index': newChapter.index,
          'title': newChapter.title,
        });
        _chapters[prodIndex] = newChapter;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteChapter(String id) async {
    final existingChapterIndex = _chapters.indexWhere((prod) => prod.id == id);
    var existingChapter = _chapters[existingChapterIndex];
    _chapters.removeAt(existingChapterIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(_book.id)
          .collection(chaptersTableName)
          .doc(id)
          .delete();
      existingChapter = null;
    } catch (e) {
      _chapters.insert(existingChapterIndex, existingChapter);
      notifyListeners();
      throw e;
    }
  }
}
