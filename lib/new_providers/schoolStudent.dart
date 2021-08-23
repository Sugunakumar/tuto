import 'package:flutter/material.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/member.dart';

class SchoolStudent {
  final String fatherName;
  final String motherName;
  final String previousSchool;
  final Grade previousSchoolGrade;
  final String studenNumber;
  final DateTime dateOfBirth;
  final DateTime joiningDate;
  final int emergencyContact;
  final int totalFee;
  final int paidFee;
  final Member user;

  SchoolStudent({
    @required this.fatherName,
    @required this.motherName,
    @required this.previousSchool,
    @required this.previousSchoolGrade,
    @required this.studenNumber,
    @required this.dateOfBirth,
    @required this.joiningDate,
    @required this.user,
    this.emergencyContact,
    this.totalFee,
    this.paidFee,
  });
}
