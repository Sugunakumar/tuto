import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../providers/auth.dart';
import '../../widgets/questions_list.dart';
import '../../providers/chapters.dart';
import '../../providers/questions.dart';
import '../edit/edit_question.dart';

enum FilterOptions {
  OnlyQuestions,
  WithAnswers,
}

class ChapterDetailScreen extends StatefulWidget {
  static const routeName = '/chapter-questions';

  @override
  _ChapterDetailScreenState createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  var _showOnlyQuestions = false;
  @override
  Widget build(BuildContext context) {
    final chapterId = ModalRoute.of(context).settings.arguments as String;

    print("chapterId : " + chapterId);

    final authData = Provider.of<Auth>(context, listen: false);
    final chaptersData = Provider.of<Chapters>(context, listen: false);
    final questionsData = Provider.of<Questions>(context, listen: false);
    final loadedChapter = chaptersData.findChapterById(chapterId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedChapter.title),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.OnlyQuestions) {
                  _showOnlyQuestions = true;
                } else {
                  _showOnlyQuestions = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Questions'),
                value: FilterOptions.OnlyQuestions,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.WithAnswers,
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditQuestionScreen.routeName);
            },
          ),
        ],
      ),
      body: loadedChapter.questions.isEmpty
          ? FutureBuilder(
              future: questionsData.fetchAndSetQuestion(
                  chaptersData.bookId, chapterId),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  print(dataSnapshot.error.toString());
                  return Center(child: Text('An Error occured'));
                } else {
                  return QuestionsList(loadedChapter, _showOnlyQuestions);
                }
              })
          : QuestionsList(loadedChapter, _showOnlyQuestions),
      floatingActionButton: authData.hasAccess(Entity.Question, Operations.Add)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditQuestionScreen.routeName),
            )
          : Container(),
    );
  }
}
