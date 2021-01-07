import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/providers/chapters.dart';
import 'package:tuto/screens/edit_chapter.dart';

import '../widgets/chapters_list.dart';
import '../providers/books.dart';



class BookDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    final bookId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    print("bookId : " + bookId);
    final loadedBook = Provider.of<Books>(
      context,
      listen: false,
    ).findBookById(bookId);
    //final chapters = loadedBook.fetchAndSetChapters(bookId);
    //print("chapters length : " + chapters.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedBook.title.toUpperCase()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditChapterScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          //future: loadedBook.fetchAndSetChapters(),
          future: Provider.of<Chapters>(
            context,
            listen: false,
          ).fetchAndSetChapters(bookId),
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
              return ChaptersList();
              // return Consumer<Chapters>(
              //   builder: (ctx, chapterData, child) => ListView.builder(
              //     itemCount: chapterData.chapters.length,
              //     itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              //       value: chapterData.chapters[i],
              //       child: ChapterList(),
              //     ),
              //   ),
              // );
            }
          }),
      floatingActionButton: authData.hasAccess(Entity.Chapter, Operations.Add)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditChapterScreen.routeName),
            )
          : Container(),
    );
  }
}

// body: Column(
//   children: <Widget>[
//     Container(
//       height: 300,
//       width: double.infinity,
//       child: Image.network(
//         loadedProduct.imageUrl,
//         fit: BoxFit.cover,
//       ),
//     ),
//     SizedBox(height: 10),
//     Text(
//       '\$${loadedProduct.price}',
//       style: TextStyle(
//         color: Colors.grey,
//         fontSize: 20,
//       ),
//     ),
//     SizedBox(
//       height: 10,
//     ),
//     Container(
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       width: double.infinity,
//       child: Text(
//         loadedProduct.description,
//         textAlign: TextAlign.center,
//         softWrap: true,
//       ),
//     ),
//     SizedBox(
//       height: 10,
//     ),
//     // Container(
//     //   padding: EdgeInsets.symmetric(horizontal: 10),
//     //   width: double.infinity,
//     //   child: Padding(
//     //     padding: EdgeInsets.all(8),
//     //     child: Text("data"),
//     //     // child: ListView.builder(
//     //     //   itemCount: chapters.length,
//     //     //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//     //     //     // builder: (c) => products[i],
//     //     //     value: chapters[i],
//     //     //     child: ChapterItem(),
//     //     //   ),
//     //     // ),
//     //   ),
//     // ),
//     new Expanded(
//         child: ListView.builder(
//       itemCount: chapters.length,
//       itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//         value: chapters[i],
//         child: ChapterItem(),
//       ),
//     ))
//   ],
// ),
