import 'package:flutter/material.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/classTeacher.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';

class ClassBook {
  final DateTime joiningDate;
  final Book book;
  final SchoolTeacher teacher;

  ClassBook({
    @required this.joiningDate,
    @required this.book,
    this.teacher,
  });
}
