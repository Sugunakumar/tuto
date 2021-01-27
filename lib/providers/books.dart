import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './../models/book.dart';
import '../data/constants.dart';
import '../common/utils.dart';

class Books with ChangeNotifier {
  final bookTable = tables['books'];
  final chapterTable = tables['chapters'];

  final db = FirebaseFirestore.instance;

  List<Book> _items = [];

// imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  List<Book> get items {
    return _items.toList();
  }

  List<Book> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Book findBookById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetBooks(String userId) async {
    print("fetchAndSetBooks");
    final List<Book> loadedBooks = [];
    try {
      final snapshot = await db.collection(bookTable).get();
      if (snapshot.size == 0) return;
      final userFavSnapshot = await db.collection(userTable).doc(userId).get();

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
      'editor': book.editor.inCaps,
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
        editor: book.editor.inCaps,
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
