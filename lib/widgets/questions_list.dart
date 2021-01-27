import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chapter.dart';
import '../providers/questions.dart';
import '../widgets/question_item.dart';

class QuestionsList extends StatelessWidget {
  final Chapter _loadedChapter;
  final bool _showOnlyQuestions;

  QuestionsList(this._loadedChapter, this._showOnlyQuestions);

  @override
  Widget build(BuildContext context) {
    return Consumer<Questions>(builder: (ctx, allQuestions, _) {
      final questions = allQuestions.questions;
      _loadedChapter.questions = questions;
      return ListView.builder(
        itemCount: questions.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: questions[i],
          child: QuestionItem(_showOnlyQuestions),
        ),
      );
    });
  }
}
