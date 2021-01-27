import 'package:flutter/foundation.dart';
import 'package:tuto/models/book.dart';
import 'package:tuto/models/task.dart';

class Admin with ChangeNotifier {
  final String id;
  final String userId;
  final List<Task> assignedTasks;
  final List<Task> createdTasks;

  Admin({
    @required this.id,
    @required this.userId,
    this.assignedTasks,
    this.createdTasks,
  });
}
