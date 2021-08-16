import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/book.dart';

import '../../data/constants.dart';
import '../../providers/auth.dart';
import '../edit/edit_chapter.dart';
import '../../widgets/list/chapters_list.dart';

// Book _loadedBook;

// class BookProfile extends StatefulWidget {
//   static const routeName = '/book-chapters';
//   static String bookId;


//   @override
//   _BookProfileState createState() => _BookProfileState();
// }

// class _BookProfileState extends State<BookProfile> with SingleTickerProviderStateMixin  {
//   @override
//   Widget build(BuildContext context) {
//     final authData = Provider.of<Auth>(context, listen: false);
//     //final booksData = Provider.of<Books>(context, listen: false);
//     //final chaptersData = Provider.of<Chapters>(context, listen: false);

//     //final loadedBook = ModalRoute.of(context).settings.arguments as Book; // is the id!
//     //print("bookId : " + bookId);
//     //final loadedBook = booksData.findBookById(bookId);
//     //final chapters = loadedBook.fetchAndSetChapters(bookId);
//     //print("chapters length : " + chapters.length.toString());

//     final bookData = Provider.of<BookNotifier>(context, listen: false);
//     final loadedBook = bookData.book;
//     print("loadedBook.name : " + loadedBook.title);
//     print("bookData.school.name : " + bookData.school.name);
//     print("bookData.clazz.name : " + bookData.clazz.name);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(loadedBook.title.toUpperCase()),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.of(context).pushNamed(EditChapterScreen.routeName);
//             },
//           ),
//         ],
//       ),
//       body: bookData.chapters.isEmpty
//           ? FutureBuilder(
//               future: bookData.fetchAndSetChapters(),
//               //future: chaptersData.fetchAndSetChapters(bookId),
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (dataSnapshot.error != null) {
//                   // Error handling
//                   print(dataSnapshot.error.toString());
//                   return Center(child: Text('An Error occured book'));
//                 } else {
//                   return ChaptersList(bookData.chapters);
//                   // return Consumer<Chapters>(
//                   //   builder: (ctx, chapterData, child) => ListView.builder(
//                   //     itemCount: chapterData.chapters.length,
//                   //     itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//                   //       value: chapterData.chapters[i],
//                   //       child: ChapterList(),
//                   //     ),
//                   //   ),
//                   // );
//                 }
//               })
//           : ChaptersList(bookData.chapters),
//       floatingActionButton: authData.hasAccess(Entity.Chapter, Operations.Add)
//           ? FloatingActionButton(
//               child: Icon(Icons.add),
//               onPressed: () =>
//                   Navigator.of(context).pushNamed(EditChapterScreen.routeName),
//             )
//           : Container(),
//     );
//   }
// }

// // body: Column(
// //   children: <Widget>[
// //     Container(
// //       height: 300,
// //       width: double.infinity,
// //       child: Image.network(
// //         loadedProduct.imageUrl,
// //         fit: BoxFit.cover,
// //       ),
// //     ),
// //     SizedBox(height: 10),
// //     Text(
// //       '\$${loadedProduct.price}',
// //       style: TextStyle(
// //         color: Colors.grey,
// //         fontSize: 20,
// //       ),
// //     ),
// //     SizedBox(
// //       height: 10,
// //     ),
// //     Container(
// //       padding: EdgeInsets.symmetric(horizontal: 10),
// //       width: double.infinity,
// //       child: Text(
// //         loadedProduct.description,
// //         textAlign: TextAlign.center,
// //         softWrap: true,
// //       ),
// //     ),
// //     SizedBox(
// //       height: 10,
// //     ),
// //     // Container(
// //     //   padding: EdgeInsets.symmetric(horizontal: 10),
// //     //   width: double.infinity,
// //     //   child: Padding(
// //     //     padding: EdgeInsets.all(8),
// //     //     child: Text("data"),
// //     //     // child: ListView.builder(
// //     //     //   itemCount: chapters.length,
// //     //     //   itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
// //     //     //     // builder: (c) => products[i],
// //     //     //     value: chapters[i],
// //     //     //     child: ChapterItem(),
// //     //     //   ),
// //     //     // ),
// //     //   ),
// //     // ),
// //     new Expanded(
// //         child: ListView.builder(
// //       itemCount: chapters.length,
// //       itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
// //         value: chapters[i],
// //         child: ChapterItem(),
// //       ),
// //     ))
// //   ],
// // ),
