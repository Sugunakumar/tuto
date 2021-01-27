import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/chapters.dart';
import '../widgets/chapter_item.dart';

class ChaptersList extends StatelessWidget {
  final Book _loadedbook;

  ChaptersList(this._loadedbook);

  @override
  Widget build(BuildContext context) {
    return Consumer<Chapters>(builder: (ctx, allChapters, _) {
      final chapters = allChapters.chapters;
      _loadedbook.chapters = chapters;

      return ListView.builder(
        itemCount: chapters.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: chapters[i],
          child: ChapterItem(),
        ),
      );
    });
  }
}
