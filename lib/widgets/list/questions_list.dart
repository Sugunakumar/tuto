import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/models.dart';
import 'package:tuto/new_providers/chapter.dart';

import '../item/question_item.dart';

// class QuestionsList extends StatelessWidget {
//   final List<Question> questions;

//   final bool _showOnlyQuestions;

//   QuestionsList(this.questions, this._showOnlyQuestions);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: questions.length,
//       itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//         value: questions[i],
//         child: QuestionItem(_showOnlyQuestions),
//       ),
//     );
//   }
// }
