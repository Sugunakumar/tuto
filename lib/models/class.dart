import 'package:flutter/foundation.dart';
import 'package:tuto/models/student.dart';
import 'package:tuto/models/subject.dart';
import 'package:tuto/models/teacher.dart';

class Class with ChangeNotifier {
  final String id;
  final String name;
  final String grade;

  Teacher classTeacher;

  List<Subject> subjects = [];

  List<Student> students = [];

  Class({
    @required this.id,
    @required this.name,
    @required this.grade,
    this.classTeacher,
  });
}
