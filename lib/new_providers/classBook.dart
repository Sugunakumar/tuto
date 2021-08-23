import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/classChapter.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/screens/profile/book_profile.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';

class ClassBook with ChangeNotifier {
  final String id;
  final DateTime joiningDate;
  final SchoolTeacher teacher;

  ClassBook({
    @required this.id,
    @required this.joiningDate,
    this.teacher,
  });

  List<ClassChapter> _classChapters;

  List<ClassChapter> get classChapters {
    return _classChapters;
  }

  set teacher(SchoolTeacher schoolTeacher) {
    this.teacher = schoolTeacher;
  }

  Future<void> fetchAndSetChapters() async {
    print("fetch class chapters entry");
    final List<ClassChapter> loadedChapters = [];

    print(schoolsTableName + " : " + SchoolProfile.schoolId);
    print(classesTableName + " : " + ClassProfile.classId);
    print(booksTableName + " : " + BookProfile.bookId);
    print(chaptersTableName + " : " + BookProfile.bookId);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(schoolsTableName)
          .doc(SchoolProfile.schoolId)
          .collection(classesTableName)
          .doc(ClassProfile.classId)
          .collection(booksTableName)
          .doc(BookProfile.bookId)
          .collection(chaptersTableName)
          .get();
      print('snapshot.size  :   ' + snapshot.size.toString());
      if (snapshot.size == 0) {
        _classChapters = [];
        return;
      }

      snapshot.docs.forEach((doc) {
        loadedChapters.add(
          ClassChapter(id: doc.id),
        );
      });
      _classChapters = loadedChapters;
      print("fetch class chapters exit " + _classChapters.length.toString());
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }
}
