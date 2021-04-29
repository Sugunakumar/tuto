import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/models.dart';

import '../common/utils.dart';

class ClassNotifier with ChangeNotifier {
  School _school;
  Class _class;
  bool fetchAllBooks = false;

  set school(School newSchool) {
    //assert(newSchool != null);
    if (newSchool != null) _school = newSchool;
    notifyListeners();
  }

  School get school => _school;

  set clazz(Class newClass) {
    assert(newClass != null);
    _class = newClass;
    notifyListeners();
  }

  Class get clazz => _class;

  List<Book> _books = [];
  List<Student> students = [];

  List<Book> get books {
    //return _books.toList();
    return _books.where((i) => i.classId == _class.id).toList();
  }

  List<Book> get allBooks {
    return _books.toList();
  }

  // List<Book> get favoriteItems {
  //   return _books.where((prodItem) => prodItem.isFavorite).toList();
  // }

  List<Book> findAllBooksByName(String searchText) {
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

  Future<void> fetchAndSetBooks() async {
    print("fetchAndSetFilteredBooks");
    print("_school.id " + _school.id);
    final List<Book> loaded = [];
    try {
      final classDoc = await db
          .collection(schoolsTableName)
          .doc(_school.id)
          .collection(classesTableName)
          .doc(_class.id)
          .get();

      if (!classDoc.data().containsKey('books')) {
        _books = loaded;
        print("fetchAndSetFilteredBooks : No books to display");
        return;
      }
      List<String> bookIds = List.from(classDoc.get('books'));
      print('bookIds : ' + bookIds.length.toString());

      for (var bookId in bookIds) {
        print('bookId : ' + bookId);
      }

      final snapshot = await db
          .collection(booksTableName)
          .where(FieldPath.documentId, whereIn: bookIds)
          .get();

      if (snapshot.size == 0) {
        _books = loaded;
        print("fetchAndSetFilteredBooks : Empty books");
        return;
      }

      snapshot.docs.forEach((doc) async {
        loaded.add(
          Book(
            classId: _class.id,
            id: doc.id,
            grade: doc.get('grade'),
            subject: doc.get('subject'),
            title: doc.get('title'),
            description: doc.get('description'),
            pages: doc.get('pages'),
            editor: doc.get('editor'),
            publisher: doc.get('publisher'),
            imageUrl: doc.get('imageUrl'),
          ),
        );
      });

      for (Book loadedBook in loaded) {
        final bookIndex = _books.indexWhere((prod) => prod.id == loadedBook.id);
        if (bookIndex < 0) {
          _books.add(loadedBook);
          print("added book of id : " +
              loadedBook.id +
              " - " +
              bookIndex.toString());
        } else
          _books[bookIndex] = loadedBook;
      }

      //_books = _books + loaded;

      print("_books : " + _books.length.toString());

      notifyListeners();
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> fetchAndSetAllBooks() async {
    String currentUserId = FirebaseAuth.instance.currentUser.uid;
    print("fetchAndSetBooks");
    final List<Book> loadedBooks = [];
    try {
      final snapshot = await db.collection(booksTableName).get();
      if (snapshot.size == 0) return;

      final userFavSnapshot =
          await db.collection(membersTableName).doc(currentUserId).get();

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
            // isFavorite:
            //     fav == null ? false : fav.contains(doc.id) ? true : false,
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
      //     .collection(booksTableName)
      //     .doc("1Lf87x0AKGdW4CDnzkHc")
      //     .collection("chapters")
      //     .get();
      // snapshottrial.docs.forEach((element) {
      //   print("plain way : " + element.get("title"));
      // });

      _books = loadedBooks;
      fetchAllBooks = true;
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
      final addedBook = await FirebaseFirestore.instance
          .collection(booksTableName)
          .add(newBook);
      final newBookList = Book(
        classId: _class.id,
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

      final classdoc = db
          .collection(schoolsTableName)
          .doc(_school.id)
          .collection(classesTableName)
          .doc(_class.id);

      print('before udpate');

      await classdoc.update({
        'books': FieldValue.arrayUnion([addedBook.id]),
      });

      print('after udpate');

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
