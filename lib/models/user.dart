import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tuto/data/constants.dart';



class CurrentUser with ChangeNotifier {
  final String id;
  final String email;
  final String username;
  final File image;
  final Role role;
  final String school;

  CurrentUser({
    @required this.id,
    @required this.email,
    @required this.username,
    @required this.image,
    this.role = Role.Student,
    this.school,
  });
}
