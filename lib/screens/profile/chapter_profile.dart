import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/chapter.dart';

import '../../data/constants.dart';
import '../../providers/auth.dart';
import '../../widgets/list/questions_list.dart';
import '../edit/edit_question.dart';

enum FilterOptions {
  OnlyQuestions,
  WithAnswers,
}

// class ChapterProfile extends StatefulWidget {
//   static const routeName = '/chapter-questions';

//   @override
//   _ChapterProfileState createState() => _ChapterProfileState();
// }

// class _ChapterProfileState extends State<ChapterProfile> {
//   var _showOnlyQuestions = false;
//   @override
//   Widget build(BuildContext context) {
//     // final loadedChapter = ModalRoute.of(context).settings.arguments as Chapter;

//     // print("chapter title: " + loadedChapter.title);

//     final authData = Provider.of<Auth>(context, listen: false);
//     // final chaptersData = Provider.of<Chapters>(context, listen: false);
//     // final questionsData = Provider.of<Questions>(context, listen: false);
//     // final loadedChapter = chaptersData.findChapterById(chapterId);

//     final chapterData = Provider.of<ChapterNotifier>(context, listen: false);
//     final loadedChapter = chapterData.book;
//     print("loadedBook.name : " + loadedChapter.title);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(loadedChapter.title),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: (FilterOptions selectedValue) {
//               setState(() {
//                 if (selectedValue == FilterOptions.OnlyQuestions) {
//                   _showOnlyQuestions = true;
//                 } else {
//                   _showOnlyQuestions = false;
//                 }
//               });
//             },
//             icon: Icon(
//               Icons.more_vert,
//             ),
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 child: Text('Only Questions'),
//                 value: FilterOptions.OnlyQuestions,
//               ),
//               PopupMenuItem(
//                 child: Text('Show All'),
//                 value: FilterOptions.WithAnswers,
//               ),
//             ],
//           ),
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.of(context).pushNamed(EditQuestionScreen.routeName);
//             },
//           ),
//         ],
//       ),
//       body: chapterData.questions.isEmpty
//           ? FutureBuilder(
//               future: chapterData.fetchAndSetQuestion(),
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (dataSnapshot.error != null) {
//                   // Error handling
//                   print(dataSnapshot.error.toString());
//                   return Center(child: Text('An Error occured'));
//                 } else {
//                   return QuestionsList(
//                       chapterData.questions, _showOnlyQuestions);
//                 }
//               })
//           : QuestionsList(chapterData.questions, _showOnlyQuestions),
//       floatingActionButton: authData.hasAccess(Entity.Question, Operations.Add)
//           ? FloatingActionButton(
//               child: Icon(Icons.add),
//               onPressed: () =>
//                   Navigator.of(context).pushNamed(EditQuestionScreen.routeName),
//             )
//           : Container(),
//     );
//   }
// }
