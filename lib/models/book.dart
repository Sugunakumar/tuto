import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/models/class.dart';
import 'package:tuto/models/school.dart';

import './../models/book.dart';
import '../data/constants.dart';
import '../common/utils.dart';

import '../models/chapter.dart';
import '../data/constants.dart';

final bookTable = tables['books'];
final userTable = tables['users'];

class Book with ChangeNotifier {
  static final String tableName = 'products';

  final String id;
  final String grade;
  final String subject;
  final String title;
  final String description;
  final int pages;
  final String editor;
  final String publisher;
  final String imageUrl;

  bool isFavorite;
  List<Chapter> chapters = [];

  Book({
    @required this.id,
    @required this.grade,
    @required this.subject,
    @required this.description,
    @required this.title,
    @required this.pages,
    @required this.editor,
    @required this.publisher,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    print("toggleFavoriteStatus");
    notifyListeners();
    try {
      if (isFavorite)
        await FirebaseFirestore.instance
            .collection(userTable)
            .doc(userId)
            .update({
          'favorites': FieldValue.arrayUnion([id]),
        });
      else
        await FirebaseFirestore.instance
            .collection(userTable)
            .doc(userId)
            .update({
          'favorites': FieldValue.arrayRemove([id]),
        });
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
      print(e);
    }
  }
}

class BookModel with ChangeNotifier {
  final bookTable = tables['books'];
  final chapterTable = tables['chapters'];

  final db = FirebaseFirestore.instance;

  List<Book> _items = [];

  School _school;
  Class _class;

  School get school => _school;

  set school(School newSchool) {
    assert(newSchool != null);
    _school = newSchool;
    notifyListeners();
  }

// imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',

  List<Book> get books {
    return _items.toList();
  }

  List<Book> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Book findBookById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetBooks({Class clazz}) async {
    _class = clazz;
    String currentUserId = FirebaseAuth.instance.currentUser.uid;
    print("fetchAndSetBooks");
    final List<Book> loadedBooks = [];
    try {
      final snapshot = await db.collection(bookTable).get();
      if (snapshot.size == 0) return;
      final userFavSnapshot =
          await db.collection(userTable).doc(currentUserId).get();

      List<dynamic> fav = userFavSnapshot.data().containsKey('favorites')
          ? userFavSnapshot.get('favorites')
          : null;

      //print("fav : " + fav.toString());

      snapshot.docs.forEach((doc) async {
        loadedBooks.add(
          Book(
            id: doc.id,
            grade: doc.get('grade'),
            subject: doc.get('subject'),
            title: doc.get('title'),
            description: doc.get('description'),
            pages: doc.get('pages'),
            editor: doc.get('editor'),
            publisher: doc.get('publisher'),
            imageUrl: doc.get('imageUrl'),
            isFavorite:
                fav == null ? false : fav.contains(doc.id) ? true : false,
          ),
        );

        //print(doc.id);
      });

      // final snapshotQ =
      //     await FirebaseFirestore.instance.collectionGroup("questions").get();
      // snapshotQ.docs.forEach((element) {
      //   print("questions : " + element.get("answer"));
      // });

      // final snapshotChap =
      //     await FirebaseFirestore.instance.collectionGroup("chapters").get();
      // snapshotChap.docs.forEach((element) {
      //   print("chapters : " + element.get("title"));
      // });

      // final snapshottrial = await FirebaseFirestore.instance
      //     .collection(bookTable)
      //     .doc("1Lf87x0AKGdW4CDnzkHc")
      //     .collection("chapters")
      //     .get();
      // snapshottrial.docs.forEach((element) {
      //   print("plain way : " + element.get("title"));
      // });

      _items = loadedBooks;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addBook(Book book) async {
    final newBook = {
      'grade': book.grade,
      'subject': book.subject.capitalizeFirstofEach,
      'title': book.title.capitalizeFirstofEach,
      'description': book.description,
      'pages': book.pages,
      'editor': book.editor.inFirstLetterCaps,
      'publisher': book.publisher.capitalizeFirstofEach,
      'imageUrl': book.imageUrl
    };

    try {
      final addedBook =
          await FirebaseFirestore.instance.collection(bookTable).add(newBook);
      final newBookList = Book(
        id: addedBook.id,
        grade: book.grade,
        subject: book.subject.capitalizeFirstofEach,
        title: book.title.capitalizeFirstofEach,
        description: book.description,
        pages: book.pages,
        editor: book.editor.inFirstLetterCaps,
        publisher: book.publisher.capitalizeFirstofEach,
        imageUrl: book.imageUrl,
      );
      //_items.add(newBookList);
      _items.insert(0, newBookList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateBook(String id, Book newBook) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance.collection(bookTable).doc(id).update({
          'grade': newBook.grade,
          'subject': newBook.subject,
          'title': newBook.title,
          'description': newBook.description,
          'pages': newBook.pages,
          'editor': newBook.editor,
          'publisher': newBook.publisher,
          'imageUrl': newBook.imageUrl
        });
        _items[prodIndex] = newBook;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteBook(String id) async {
    final existingBookIndex = _items.indexWhere((prod) => prod.id == id);
    var existingBook = _items[existingBookIndex];
    _items.removeAt(existingBookIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection(bookTable).doc(id).delete();
      existingBook = null;
    } catch (e) {
      _items.insert(existingBookIndex, existingBook);
      notifyListeners();
      throw e;
    }
  }
}
