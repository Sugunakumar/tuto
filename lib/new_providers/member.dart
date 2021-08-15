import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuto/new_providers/models.dart';

import '../data/constants.dart';

class Member {
  final String id;
  final String email;
  final String username;
  final String imageURL;
  String schoolId;
  List<Role> roles;
  List<String> classIds;

  Member({
    @required this.id,
    @required this.email,
    @required this.username,
    @required this.imageURL,
    this.schoolId,
    this.roles,
    this.classIds,
  });
}
