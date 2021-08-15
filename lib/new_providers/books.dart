import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/new_providers/book.dart';

import 'package:tuto/new_providers/school.dart';

import 'package:tuto/providers/auth.dart';

import '../data/constants.dart';

class Books with ChangeNotifier {
  final db = FirebaseFirestore.instance;

  List<Book> _books = [];

// imageUrl:
// 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',

  List<Book> get books {
    return _books.toList();
  }

  // List<Book> get favoriteItems {
  //   return _books.where((prodItem) => prodItem.isFavorite).toList();
  // }

  List<Book> findBooksByName(String searchText) {
    if (searchText.isEmpty) {
      return _books.toList();
    }
    return _books
        .where((s) => s.title.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
  }

  Book findBookById(String id) {
    return _books.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetBooks(Auth auth, School school) async {
    final List<Book> loadedBooks = [];
    var snapshot;
    try {
      // teacher

      if (school != null) {
        List<String> gradeS = school.findGradesForClasses(school.classes);
        print('grades : ' + gradeS.toString());

        snapshot = await db
            .collection(booksTableName)
            .where('grade', whereIn: gradeS)
            .get();
      } else if (auth.isAdmin())
        snapshot = await db.collection(booksTableName).get();
      else
        print('to be handled');

      if (snapshot.size == 0) return;
      // final userFavSnapshot =
      //     await db.collection(membersTableName).doc(currentUserId).get();

      // List<dynamic> fav = userFavSnapshot.data().containsKey('favorites')
      //     ? userFavSnapshot.get('favorites')
      //     : null;

      //print("fav : " + fav.toString());

      print("fetchAndSetBooks found : " + snapshot.size.toString());

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
            // isFavorite:
            //     fav == null ? false : fav.contains(doc.id) ? true : false,
          ),
        );

        //print(doc.id);
      });

      // for (var bookId in bookIds) {
      //   final itemIndex = loadedBooks.indexWhere((item) => item.id == bookId);
      //   loadedBooks.insert(0, loadedBooks.removeAt(itemIndex));
      // }

      _books = loadedBooks;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addBook(Book book) async {
    final newBook = {
      'grade': book.grade,
      'subject': book.subject,
      'title': book.title,
      'description': book.description,
      'pages': book.pages,
      'editor': book.editor,
      'publisher': book.publisher,
      'imageUrl': book.imageUrl
    };

    try {
      final addedBook = await FirebaseFirestore.instance
          .collection(booksTableName)
          .add(newBook);
      final newBookList = Book(
        id: addedBook.id,
        grade: book.grade,
        subject: book.subject,
        title: book.title,
        description: book.description,
        pages: book.pages,
        editor: book.editor,
        publisher: book.publisher,
        imageUrl: book.imageUrl,
      );
      //_books.add(newBookList);
      _books.insert(0, newBookList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateBook(String id, Book newBook) async {
    final prodIndex = _books.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(booksTableName)
            .doc(id)
            .update({
          'grade': newBook.grade,
          'subject': newBook.subject,
          'title': newBook.title,
          'description': newBook.description,
          'pages': newBook.pages,
          'editor': newBook.editor,
          'publisher': newBook.publisher,
          'imageUrl': newBook.imageUrl
        });
        _books[prodIndex] = newBook;
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
    final existingBookIndex = _books.indexWhere((prod) => prod.id == id);
    var existingBook = _books[existingBookIndex];
    _books.removeAt(existingBookIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(id)
          .delete();
      existingBook = null;
    } catch (e) {
      _books.insert(existingBookIndex, existingBook);
      notifyListeners();
      throw e;
    }
  }
}
