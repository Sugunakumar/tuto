import 'dart:io';

import 'package:flutter/foundation.dart';

class Answer with ChangeNotifier {
  final String id;
  final String answer;
  final String answerImageURL;

  Answer({
    @required this.id,
    @required this.answer,
    @required this.answerImageURL,
  });
}
