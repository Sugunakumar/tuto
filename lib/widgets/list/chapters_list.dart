import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/chapter.dart';

import '../item/chapter_item.dart';

class ChaptersList extends StatelessWidget {
  final List<Chapter> chapters;
  ChaptersList(this.chapters);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chapters.length,
      itemBuilder: (ctx, i) => ChapterItem(chapters[i]),
      // ChangeNotifierProvider.value(
      //   value: _loadedbook.chapters[i],
      //   child: ChapterItem(),
      // ),
    );
  }
}
