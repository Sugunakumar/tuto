import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum TaskStatus { NotStarted, InProgress, Completed }

class Task with ChangeNotifier {
  final String id;
  final String name;
  final String createdById;
  final String assignedToId;
  final TaskStatus status;

  User createdBy;
  User assignedTo;

  DateTime deadline;

  Task({
    @required this.id,
    @required this.name,
    @required this.createdById,
    @required this.assignedToId,
    this.status = TaskStatus.NotStarted,
  });
}
