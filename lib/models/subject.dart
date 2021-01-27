import 'package:flutter/foundation.dart';
import '../models/homework.dart';

class Subject with ChangeNotifier {
  final String id;
  final String name;

  final List<dynamic> books;
  final List<dynamic> teachers;

  List<HomeWork> homeworks;

  Subject({
    @required this.id,
    @required this.name,
    this.books,
    this.teachers,
  });
}
