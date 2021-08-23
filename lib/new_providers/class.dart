import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';
import 'package:tuto/new_providers/classBook.dart';

import 'package:tuto/new_providers/classStudent.dart';
import 'package:tuto/new_providers/classTeacher.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/profile/school_profile.dart';

class Class with ChangeNotifier {
  final String id;
  final String name;
  final String icon;
  final Grade grade;
  final String academicYear;
  final SchoolTeacher classTeacher;

  List<ClassStudent> _students;
  List<ClassBook> _books;

  Class({
    @required this.id,
    @required this.name,
    @required this.grade,
    @required this.icon,
    @required this.academicYear,
    this.classTeacher,
  });

  List<ClassStudent> get students => _students;
  List<ClassBook> get books => _books;

  //bool fetchAllClassBooks = false;

  List<ClassBook> get allClassBooks {
    return _books.toList();
  }

  set classTeacher(SchoolTeacher schoolTeacher) {
    this.classTeacher = schoolTeacher;
  }

  ClassBook findClassBookById(String id) {
    print('findClassBookById      :  ' + id.toString());
    print('_books      :  ' + _books.length.toString());
    return _books.firstWhere((i) => i.id == id);
  }

  Future<List<ClassBook>> fetchAndSetClassBooks() async {
    print("fetchAndSetFilteredClassBooks : " + SchoolProfile.schoolId);
    print("fetchAndSetFiltered : " + id);

    //print("schoolId " + schoolId);
    final List<ClassBook> loaded = [];
    try {
      final classBookSnapshot = await db
          .collection(schoolsTableName)
          .doc(SchoolProfile.schoolId)
          .collection(classesTableName)
          .doc(this.id)
          .collection(booksTableName)
          .get();

      print("classBookSnapshot : " + classBookSnapshot.size.toString());

      if (classBookSnapshot.size == 0) {
        _books = loaded;
        return loaded;
      }

      classBookSnapshot.docs.forEach((doc) {
        loaded.add(
          ClassBook(
            id: doc.id,
            joiningDate:
                DateTime.parse(doc.get('joiningDate').toDate().toString()),
          ),
        );
      });

      //_books = _books + loaded;
      _books = loaded;
      print("_books : " + _books.length.toString());

      notifyListeners();

      return _books;
    } catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  // Future<void> fetchAndSetAllClassBooks() async {
  //   String currentUserId = FirebaseAuth.instance.currentUser.uid;
  //   print("fetchAndSetClassBooks");
  //   final List<ClassBook> loadedClassBooks = [];
  //   try {
  //     final snapshot = await db.collection(booksTableName).get();
  //     if (snapshot.size == 0) return;

  //     final userFavSnapshot =
  //         await db.collection(membersTableName).doc(currentUserId).get();

  //     List<dynamic> fav = userFavSnapshot.data().containsKey('favorites')
  //         ? userFavSnapshot.get('favorites')
  //         : null;

  //     //print("fav : " + fav.toString());

  //     snapshot.docs.forEach((doc) async {
  //       loadedClassBooks.add(
  //         ClassBook(
  //           id: doc.id,
  //           grade: doc.get('grade'),
  //           subject: doc.get('subject'),
  //           title: doc.get('title'),
  //           description: doc.get('description'),
  //           pages: doc.get('pages'),
  //           editor: doc.get('editor'),
  //           publisher: doc.get('publisher'),
  //           imageUrl: doc.get('imageUrl'),
  //           // isFavorite:
  //           //     fav == null ? false : fav.contains(doc.id) ? true : false,
  //         ),
  //       );

  //       //print(doc.id);
  //     });

  //     // final snapshotQ =
  //     //     await FirebaseFirestore.instance.collectionGroup("questions").get();
  //     // snapshotQ.docs.forEach((element) {
  //     //   print("questions : " + element.get("answer"));
  //     // });

  //     // final snapshotChap =
  //     //     await FirebaseFirestore.instance.collectionGroup("chapters").get();
  //     // snapshotChap.docs.forEach((element) {
  //     //   print("chapters : " + element.get("title"));
  //     // });

  //     // final snapshottrial = await FirebaseFirestore.instance
  //     //     .collection(booksTableName)
  //     //     .doc("1Lf87x0AKGdW4CDnzkHc")
  //     //     .collection("chapters")
  //     //     .get();
  //     // snapshottrial.docs.forEach((element) {
  //     //   print("plain way : " + element.get("title"));
  //     // });

  //     _books = loadedClassBooks;
  //     fetchAllClassBooks = true;
  //     notifyListeners();
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future<void> addClassBook(ClassBook classBook, String schoolId) async {
    try {
      await FirebaseFirestore.instance
          .collection(schoolsTableName)
          .doc(schoolId)
          .collection(classesTableName)
          .doc(this.id)
          .collection(booksTableName)
          .doc(classBook.id)
          .set({
        "joiningDate": DateTime.now(),
      });

      final newClassBookList = ClassBook(
        joiningDate: classBook.joiningDate,
        id: classBook.id,
        teacher: classBook.teacher,
      );

      _books.insert(0, newClassBookList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  // Future<void> updateClassBook(String id, ClassBook newClassBook) async {
  //   final prodIndex = _books.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     try {
  //       await FirebaseFirestore.instance
  //           .collection(booksTableName)
  //           .doc(id)
  //           .update({
  //         'grade': newClassBook.grade,
  //         'subject': newClassBook.subject,
  //         'title': newClassBook.title,
  //         'description': newClassBook.description,
  //         'pages': newClassBook.pages,
  //         'editor': newClassBook.editor,
  //         'publisher': newClassBook.publisher,
  //         'imageUrl': newClassBook.imageUrl
  //       });
  //       _books[prodIndex] = newClassBook;
  //       notifyListeners();
  //     } catch (e) {
  //       print(e);
  //       throw e;
  //     }
  //   } else {
  //     print('...');
  //   }
  // }

  Future<void> deleteClassBook(String id) async {
    final existingClassBookIndex = _books.indexWhere((prod) => prod.id == id);
    var existingClassBook = _books[existingClassBookIndex];
    _books.removeAt(existingClassBookIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(id)
          .delete();
      existingClassBook = null;
    } catch (e) {
      _books.insert(existingClassBookIndex, existingClassBook);
      notifyListeners();
      throw e;
    }
  }
}
