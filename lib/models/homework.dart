import 'package:flutter/foundation.dart';
import 'package:tuto/new_providers/task.dart';

class HomeWork extends Task {
  final String homeworkImageURL;

  HomeWork({
    @required id,
    @required name,
    @required createdBy,
    @required assignedTo,
    status = TaskStatus.NotStarted,
    this.homeworkImageURL,
  });
}
