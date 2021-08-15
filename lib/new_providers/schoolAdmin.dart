import 'package:flutter/material.dart';
import 'package:tuto/new_providers/member.dart';

class SchoolAdmin {
  final String qualification;
  final DateTime joiningDate;

  final Member user;

  SchoolAdmin({
    @required this.qualification,
    @required this.joiningDate,
    @required this.user,
  });
}
