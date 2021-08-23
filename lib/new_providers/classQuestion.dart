import 'package:flutter/foundation.dart';
import 'package:tuto/new_providers/answer.dart';

enum QuestionType {
  Objective,
  Descriptive,
}

enum Approval { Approved, Rejected, Pending }

enum Importance { Least, Maybe, MostLikely, Important, Must }

class ClassQuestion with ChangeNotifier {
  final String id;
  final String answerId;
  List<String> incorrectAnswers;
  //final Approval approval;
  //final String comment;

  ClassQuestion({
    @required this.id,
    @required this.answerId,
    this.incorrectAnswers,
  });
}
