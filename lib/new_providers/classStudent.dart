import 'package:flutter/material.dart';
import 'package:tuto/new_providers/schoolStudent.dart';

class ClassStudent {
  final DateTime joiningDate;
  final int roleNumber;
  final SchoolStudent schoolStudent;

  ClassStudent({
    @required this.joiningDate,
    @required this.roleNumber,
    @required this.schoolStudent,
  });
}
