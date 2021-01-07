import 'dart:io';

import 'package:flutter/foundation.dart';

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
  final String answer;
  final List<dynamic> incorrectAnswers;
  //final Approval approval;
  //final String comment;
  final String questionImageURL;
  final String answerImageURL;

  Question({
    @required this.id,
    @required this.mark,
    @required this.type,
    @required this.question,
    @required this.answer,
    this.incorrectAnswers,

    //this.approval = Approval.Pending,
    //this.comment,
    this.questionImageURL,
    this.answerImageURL,
  });
}
