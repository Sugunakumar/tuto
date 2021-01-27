import 'package:flutter/foundation.dart';
import 'package:tuto/models/task.dart';

class Teacher with ChangeNotifier {
  final String userId;
  final String name;
  final String imageURL;

  List<Task> assignedTasks;
  List<Task> createdTasks;

  Teacher({
    @required this.userId,
    @required this.name,
    @required this.imageURL,
    this.assignedTasks,
    this.createdTasks,
  });
}
