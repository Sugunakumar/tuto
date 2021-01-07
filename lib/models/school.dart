import 'dart:io';
import 'package:flutter/foundation.dart';

class School with ChangeNotifier {
  final String id;
  final String name;
  final String address;
  final File image;

  School(this.id, this.name, this.address, this.image);
}