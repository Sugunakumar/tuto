import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/constants.dart';
import './../models/chapter.dart';

final bookTable = tables['books'];

class Chapters with ChangeNotifier {
  final chapterTable = tables['chapters'];
  String _bookId;

  List<Chapter> _items = [];

  // set _bookId(String id) {
  //   this._bookId = id;
  // }

  String get bookId {
    return this._bookId;
  }

  List<Chapter> get chapters {
    return _items.toList();
  }

  Chapter findChapterById(String id) {
    return _items.firstWhere((chap) => chap.id == id);
  }

  Future<void> fetchAndSetChapters(String bookId) async {
    print("fetchAndSetChapters entry");
    final List<Chapter> loadedChapters = [];
    this._bookId = bookId;
    print("book id set to : " + this._bookId);
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(bookTable)
          .doc(bookId)
          .collection(chapterTable)
          .orderBy('index')
          .get();
      if (snapshot.size == 0) {
        _items = [];
        return;
      }
      snapshot.docs.forEach((doc) {
        loadedChapters.add(
          Chapter(
            id: doc.id,
            index: doc.get('index'),
            title: doc.get('title'),
          ),
        );
        print(doc.get('title'));
        print(doc.id);
      });
      _items = loadedChapters;
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
          .collection(bookTable)
          .doc(_bookId)
          .collection(chapterTable)
          .add(newChapter);
      final newChapterList = Chapter(
        id: addedChapter.id,
        index: chapter.index,
        title: chapter.title,
      );
      _items.add(newChapterList);
      //_items.insert(0, newChapterList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateChapter(String id, Chapter newChapter) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(bookTable)
            .doc(_bookId)
            .collection(chapterTable)
            .doc(id)
            .update({
          'index': newChapter.index,
          'title': newChapter.title,
        });
        _items[prodIndex] = newChapter;
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
    final existingChapterIndex = _items.indexWhere((prod) => prod.id == id);
    var existingChapter = _items[existingChapterIndex];
    _items.removeAt(existingChapterIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(bookTable)
          .doc(_bookId)
          .collection(chapterTable)
          .doc(id)
          .delete();
      existingChapter = null;
    } catch (e) {
      _items.insert(existingChapterIndex, existingChapter);
      notifyListeners();
      throw e;
    }
  }
}
