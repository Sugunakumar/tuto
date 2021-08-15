import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/models.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/widgets/item/book_item.dart';

/// This is the stateless widget that the main application instantiates.
// class ClassBookListTab extends StatelessWidget {
//   final Class loadedClass;

//   ClassBookListTab(this.loadedClass, {Key key}) : super(key: key);

//   Future<void> _refresh(BuildContext context) async {
//     print('_refresh belongsToClass');
//     await Provider.of<ClassNotifier>(context, listen: false).fetchAndSetBooks();

//     final bok = Provider.of<ClassNotifier>(context, listen: false).books;
//     print('no of books' + bok.length.toString());

//     //await loadedClass.fetchAndSetBooks();

//     //Books booksData = Provider.of<Books>(context, listen: false);
//     // ClassProvider classProvider =
//     //     Provider.of<ClassProvider>(context, listen: false);
//     // await classProvider.fetchAndSetBooks();
//     // await booksData.fetchAndSetFilteredBooks(
//     //     classProvider.school.id, classProvider.clazz.id);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final loadedClass = Provider.of<ClassNotifier>(context, listen: false);

//     print('belongsToClass ');

//     return RefreshIndicator(
//       onRefresh: () => _refresh(context),
//       child: loadedClass.books.isNotEmpty
//           ? BookList(loadedClass.books)
//           : FutureBuilder(
//               future: _refresh(context),
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (dataSnapshot.error != null) {
//                   // Error handling
//                   return Center(child: Text('An Error occured no books'));
//                 } else if (loadedClass.books.isEmpty) {
//                   return Center(child: Text('Please add books to display'));
//                 } else {
//                   return BookList(loadedClass.books);
//                 }
//               }),
//     );
//   }
// }

// class BookList extends StatelessWidget {
//   final List<Book> books;
//   BookList(this.books);

//   @override
//   Widget build(BuildContext context) {
//     // return Consumer<Books>(builder: (ctx, allItems, _) {
//     //   final books = allItems.books;
//     print("booklist : " + books.length.toString());

//     return ListView.builder(
//       itemCount: books.length,
//       // itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//       //   value: books[i],
//       //   child: BookItem(),
//       // ),
//       itemBuilder: (ctx, i) => BookItem(books[i]),
//     );
//     //});
//   }
// }
