import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/providers/auth.dart';

import '../providers/chapters.dart';
import '../providers/questions.dart';
import './edit_question.dart';
import '../widgets/question_item.dart';

enum FilterOptions {
  OnlyQuestions,
  WithAnswers,
}

class ChapterDetailScreen extends StatefulWidget {
  static const routeName = '/chapter-detail';

  @override
  _ChapterDetailScreenState createState() => _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends State<ChapterDetailScreen> {
  var _showOnlyQuestions = false;
  @override
  Widget build(BuildContext context) {
    final Map map =
        ModalRoute.of(context).settings.arguments as Map; // is the id!

    final chapterId = map['chapterId'];
    print("chapterId : " + chapterId);

    final authData = Provider.of<Auth>(context, listen: false);

    final chaptersData = Provider.of<Chapters>(context, listen: false);

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
      body: FutureBuilder(
          future: Provider.of<Questions>(
            context,
            listen: false,
          ).fetchAndSetQuestion(chaptersData.bookId, chapterId),
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
              return Consumer<Questions>(builder: (ctx, allQuestions, _) {
                final questions = allQuestions.questions;
                return ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                    value: questions[i],
                    child: QuestionItem(_showOnlyQuestions),
                  ),
                );
              });
            }
          }),
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
