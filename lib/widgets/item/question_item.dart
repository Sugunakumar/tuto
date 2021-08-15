// import 'package:flutter/material.dart';
// import 'package:html_unescape/html_unescape.dart';
// import 'package:provider/provider.dart';
// import 'package:tuto/new_providers/models.dart';

// class QuestionItem extends StatelessWidget {
//   final bool showOnlyQuestions;

//   QuestionItem(this.showOnlyQuestions);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Consumer<Question>(
//         builder: (ctx, question, _) => Card(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Text(
//                   HtmlUnescape().convert(question.question),
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16.0),
//                 ),
//                 SizedBox(height: 5.0),
//                 showOnlyQuestions
//                     ? Container()
//                     : Text(
//                         // HtmlUnescape().convert(question.answers),
//                         HtmlUnescape().convert('question.answers'),
//                         style: TextStyle(
//                             color: Colors.green,
//                             fontSize: 18.0,
//                             fontWeight: FontWeight.bold),
//                       ),
//                 SizedBox(height: 5.0),
//                 question.incorrectAnswers == null
//                     ? Container()
//                     : Text.rich(
//                         TextSpan(children: [
//                           TextSpan(text: "Incorrect Answers: "),
//                           TextSpan(
//                               text: HtmlUnescape().convert(
//                                   question.incorrectAnswers.toString()),
//                               style: TextStyle(fontWeight: FontWeight.w500))
//                         ]),
//                         style: TextStyle(fontSize: 16.0),
//                       )
//               ],
//             ),
//           ),
//         ),
//         //   footer: GridTileBar(
//         //     backgroundColor: Colors.black87,
//         //     leading: Consumer<Book>(
//         //       builder: (ctx, book, _) => IconButton(
//         //         icon: Icon(
//         //           book.isFavorite ? Icons.favorite : Icons.favorite_border,
//         //         ),
//         //         color: Theme.of(context).accentColor,
//         //         onPressed: () {
//         //           book.toggleFavoriteStatus();
//         //         },
//         //       ),
//         //     ),
//         //     title: Text(
//         //       book.title,
//         //       textAlign: TextAlign.center,
//         //     ),
//         //     trailing: IconButton(
//         //       icon: Icon(
//         //         Icons.shopping_cart,
//         //       ),
//         //       onPressed: () {
//         //         print('book.gstAmount : ' + book.gstAmount.toString());
//         //         print('book.gst : ' + book.cgst.toString());
//         //         cart.addItem(book.id, book.pages, book.title, book.gstAmount);
//         //         Scaffold.of(context).hideCurrentSnackBar();
//         //         Scaffold.of(context).showSnackBar(
//         //           SnackBar(
//         //             content: Text(
//         //               'Added item to cart!',
//         //             ),
//         //             duration: Duration(seconds: 2),
//         //             action: SnackBarAction(
//         //               label: 'UNDO',
//         //               onPressed: () {
//         //                 cart.removeSingleItem(book.id);
//         //               },
//         //             ),
//         //           ),
//         //         );
//         //       },
//         //       color: Theme.of(context).accentColor,
//         //     ),
//         //   ),
//       ),
//     );
//   }
// }
