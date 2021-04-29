import 'package:flutter/foundation.dart';

import 'package:tuto/models/models.dart';

class Student with ChangeNotifier {
  static final String tableName = 'students';

  final Member user;
  final School school;
  final Class clazz;

  final List<Task> assignedTasks;

  Student({
    @required this.school,
    @required this.clazz,
    @required this.user,
    this.assignedTasks,
  });
}
