import 'package:flutter/material.dart';
import 'package:tuto/new_providers/member.dart';

class SchoolStudent {
  final String fatherName;
  final String motherName;
  final String previousSchool;
  final String previousSchoolGrade;
  final String studenNumber;
  final DateTime joiningDate;
  //final int feesTotal;
  final Member user;

  SchoolStudent({
    @required this.fatherName,
    @required this.motherName,
    @required this.previousSchool,
    @required this.previousSchoolGrade,
    @required this.studenNumber,
    @required this.joiningDate,
    @required this.user,
  });
}
