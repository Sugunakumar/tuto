import 'package:flutter/material.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';

class BookTeacher {
  final DateTime joiningDate;
  final SchoolTeacher schoolTeacher;

  BookTeacher({
    @required this.joiningDate,
    @required this.schoolTeacher,
  });
}
