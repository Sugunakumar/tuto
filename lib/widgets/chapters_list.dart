import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/providers/chapters.dart';
import 'package:tuto/widgets/chapter_item.dart';

import '../providers/books.dart';
import 'book_item.dart';

class ChaptersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Chapters>(builder: (ctx, allChapters, _) {
      final chapters = allChapters.chapters;
      print('chapters : ' + chapters.length.toString());
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
