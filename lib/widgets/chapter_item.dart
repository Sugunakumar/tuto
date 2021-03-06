import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/constants.dart';
import '../models/chapter.dart';
import '../providers/auth.dart';
import '../providers/chapters.dart';
import '../screens/edit/edit_chapter.dart';
import '../screens/overview/chapter_questions.dart';

class ChapterItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Consumer<Chapter>(
        builder: (ctx, chapter, _) => ListTile(
          //title: new Center(child: Text(chapter.title)),
          title: Text(chapter.title),
          leading: CircleAvatar(
            child: Text(chapter.index.toString()),
          ),
          //leading: Text(chapter.index.toString()),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                authData.hasAccess(Entity.Chapter, Operations.Update)
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              EditChapterScreen.routeName,
                              arguments: chapter.id);
                        },
                        color: Theme.of(context).primaryColor,
                      )
                    : Container(),
                authData.hasAccess(Entity.Chapter, Operations.Update)
                    ? IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await Provider.of<Chapters>(context, listen: false)
                                .deleteChapter(chapter.id);
                          } catch (e) {
                            scaffold.showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Deleting Failed',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                        },
                        color: Theme.of(context).errorColor,
                      )
                    : Container(),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).pushNamed(ChapterDetailScreen.routeName,
                arguments: chapter.id);
          },
        ),
        // leading: CircleAvatar(
        //   backgroundImage: NetworkImage(imageUrl),
        // ),
        //   trailing: Container(
        //     width: 100,
        //     child: Row(
        //       children: <Widget>[
        //         IconButton(
        //           icon: Icon(Icons.edit),
        //           onPressed: () {
        //             Navigator.of(context)
        //                 .pushNamed(EditProductScreen.routeName, arguments: id);
        //           },
        //           color: Theme.of(context).primaryColor,
        //         ),
        //         IconButton(
        //           icon: Icon(Icons.delete),
        //           onPressed: () async {
        //             try {
        //               await Provider.of<Products>(context, listen: false)
        //                   .deleteProduct(id);
        //             } catch (e) {
        //               scaffold.showSnackBar(
        //                 SnackBar(
        //                   content: Text(
        //                     'Deleting Failed',
        //                     textAlign: TextAlign.center,
        //                   ),
        //                 ),
        //               );
        //             }
        //           },
        //           color: Theme.of(context).errorColor,
        //         ),
        //       ],
        //     ),
        //   ),
        //
      ),
    );
  }
}
