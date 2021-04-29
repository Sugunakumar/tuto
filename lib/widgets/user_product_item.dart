import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit/edit_book.dart';
import '../new_providers/books.dart';

// class UserBookItem extends StatelessWidget {
//   final String id;
//   final String title;
//   final String imageUrl;

//   UserBookItem(this.id, this.title, this.imageUrl);

//   @override
//   Widget build(BuildContext context) {
//     final scaffold = Scaffold.of(context);
//     return ListTile(
//       title: Text(title),
//       leading: CircleAvatar(
//         backgroundImage: NetworkImage(imageUrl),
//       ),
//       trailing: Container(
//         width: 100,
//         child: Row(
//           children: <Widget>[
//             IconButton(
//               icon: Icon(Icons.edit),
//               onPressed: () {
//                 Navigator.of(context)
//                     .pushNamed(EditBookScreen.routeName, arguments: id);
//               },
//               color: Theme.of(context).primaryColor,
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () async {
//                 try {
//                   await Provider.of<Books>(context, listen: false)
//                       .deleteBook(id);
//                 } catch (e) {
//                   scaffold.showSnackBar(
//                     SnackBar(
//                       content: Text(
//                         'Deleting Failed',
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   );
//                 }
//               },
//               color: Theme.of(context).errorColor,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
