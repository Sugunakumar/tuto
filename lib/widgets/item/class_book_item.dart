// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tuto/new_providers/book.dart';

// import 'package:tuto/screens/profile/book_profile.dart';

// class _ArticleDescription extends StatelessWidget {
//   _ArticleDescription({
//     Key key,
//     this.title,
//     this.subtitle,
//     this.author,
//     this.publishDate,
//     this.readDuration,
//   }) : super(key: key);

//   final String title;
//   final String subtitle;
//   final String author;
//   final String publishDate;
//   final String readDuration;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Expanded(
//           flex: 2,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 '$title',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const Padding(padding: EdgeInsets.only(bottom: 2.0)),
//               Text(
//                 '$subtitle',
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 13.0,
//                   color: Colors.black54,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           flex: 1,
//           child: Row(
//             //crossAxisAlignment: CrossAxisAlignment.end, // top to bottom
//             mainAxisAlignment: MainAxisAlignment.spaceBetween, // left to right
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start, // left to right
//                 mainAxisAlignment: MainAxisAlignment.end, // top to bottom
//                 children: <Widget>[
//                   Text(
//                     '$author',
//                     style: const TextStyle(
//                       fontSize: 12.0,
//                       //color: Colors.black87,
//                     ),
//                   ),
//                   Text(
//                     '$publishDate - $readDuration',
//                     style: const TextStyle(
//                       fontSize: 12.0,
//                       //color: Colors.black54,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: <Widget>[
//                   IconButton(
//                     icon: const Icon(Icons.edit),
//                     onPressed: () {
//                       print('edit was clicked');
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class CustomListItemTwo extends StatelessWidget {
//   CustomListItemTwo({
//     Key key,
//     this.id,
//     this.thumbnail,
//     this.title,
//     this.subtitle,
//     this.author,
//     this.publishDate,
//     this.readDuration,
//   }) : super(key: key);

//   final String id;
//   final Widget thumbnail;
//   final String title;
//   final String subtitle;
//   final String author;
//   final String publishDate;
//   final String readDuration;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 3,
//       margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
//         child: InkWell(
//           onTap: () {
//             print('Book was tapped');
//             //Navigator.of(context).pushNamed(BookProfile.routeName, arguments: id);
//           },
//           // Generally, material cards use onSurface with 12% opacity for the pressed state.
//           splashColor:
//               Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
//           // Generally, material cards do not have a highlight overlay.
//           highlightColor: Colors.transparent,
//           child: SizedBox(
//             height: 100,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 AspectRatio(
//                   aspectRatio: 1.0,
//                   child: thumbnail,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
//                     child: _ArticleDescription(
//                       title: title,
//                       subtitle: subtitle,
//                       author: author,
//                       publishDate: publishDate,
//                       readDuration: readDuration,
//                     ),
//                   ),
//                 ),
//                 // IconButton(
//                 //   icon: const Icon(Icons.more_vert),
//                 //   onPressed: () {},
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class BookItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     //final authData = Provider.of<Auth>(context, listen: false);
//     final scaffold = Scaffold.of(context);
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Consumer<BookNotifier>(
//         builder: (ctx, bookNotifier, _) => ListTile(
//           title: Text(bookNotifier.book.title),
//           leading:
//               CircleAvatar(child: Image.network(bookNotifier.book.imageUrl)),
//           // trailing: Container(
//           //   width: 100,
//           //   child: Row(
//           //     children: <Widget>[
//           //       authData.hasAccess(Entity.Chapter, Operations.Update)
//           //           ? IconButton(
//           //               icon: Icon(Icons.edit),
//           //               onPressed: () {
//           //                 Navigator.of(context).pushNamed(
//           //                     EditChapterScreen.routeName,
//           //                     arguments: chapter.id);
//           //               },
//           //               color: Theme.of(context).primaryColor,
//           //             )
//           //           : Container(),
//           //       authData.hasAccess(Entity.Chapter, Operations.Update)
//           //           ? IconButton(
//           //               icon: Icon(Icons.delete),
//           //               onPressed: () async {
//           //                 try {
//           //                   await Provider.of<Chapters>(context, listen: false)
//           //                       .deleteChapter(chapter.id);
//           //                 } catch (e) {
//           //                   scaffold.showSnackBar(
//           //                     SnackBar(
//           //                       content: Text(
//           //                         'Deleting Failed',
//           //                         textAlign: TextAlign.center,
//           //                       ),
//           //                     ),
//           //                   );
//           //                 }
//           //               },
//           //               color: Theme.of(context).errorColor,
//           //             )
//           //           : Container(),
//           //     ],
//           //   ),
//           // ),
//           onTap: () {
//             print('Book was tapped');
//             //Navigator.of(context).pushNamed(BookProfile.routeName);
//             // Navigator.of(context).pushNamed(BookProfile.routeName, arguments: bookNotifier.book);
//           },
//         ),

//         // CustomListItemTwo(
//         //   id: book.id,
//         //   thumbnail: Container(
//         //     child: FittedBox(
//         //       child: Image.network(
//         //         book.imageUrl,
//         //         fit: BoxFit.cover,
//         //       ),
//         //     ),
//         //   ),
//         //   title: book.title,
//         //   subtitle: book.subject,
//         //   author: book.pages.toString(),
//         //   publishDate: book.editor,
//         //   readDuration: book.publisher,
//         // ),
//       ),
//     );
//   }
// }
