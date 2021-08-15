import 'package:flutter/foundation.dart';
import 'package:tuto/new_providers/answer.dart';

enum QuestionType {
  Objective,
  Descriptive,
}

enum Approval { Approved, Rejected, Pending }

enum Importance { Least, Maybe, MostLikely, Important, Must }

class Question with ChangeNotifier {
  final String id;
  final int mark;
  final QuestionType type;
  final String question;
  final String questionImageURL;

  List<Answer> _answers;
  List<Answer> _incorrectAnswers;
  //final Approval approval;
  //final String comment;

  Question({
    @required this.id,
    @required this.mark,
    @required this.type,
    @required this.question,
    this.questionImageURL,
  });

  List<Answer> get answers => _answers;
  List<Answer> get classes => _incorrectAnswers;
}
