import 'package:flutter/foundation.dart';
import 'package:tuto/models/task.dart';

class Student with ChangeNotifier {
  final String userId;
  final String name;
  final String imageURL;

  List<Task> assignedTasks;
  List<Task> createdTasks;

  Student({
    @required this.userId,
    @required this.name,
    @required this.imageURL,
    this.assignedTasks,
    this.createdTasks,
  });
}
