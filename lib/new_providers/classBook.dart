import 'package:flutter/material.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/classTeacher.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';

class ClassBook {
  final String id;
  final DateTime joiningDate;
  final SchoolTeacher teacher;

  ClassBook({
    @required this.id,
    @required this.joiningDate,
    this.teacher,
  });
}
