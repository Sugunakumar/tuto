import 'package:flutter/material.dart';
import 'package:tuto/new_providers/member.dart';

class SchoolTeacher {
  final String qualification;
  final int experience;
  final DateTime joiningDate;
  final int salary;
  final Member user;

  SchoolTeacher({
    @required this.qualification,
    @required this.experience,
    @required this.user,
    @required this.salary,
    this.joiningDate,
  });
}
