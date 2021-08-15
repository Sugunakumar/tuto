import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/widgets/item/book_item.dart';

class BookListTab extends StatelessWidget {
  final bool isSearching;
  final String searchText;
  BookListTab(this.isSearching, this.searchText, {Key key}) : super(key: key);

  Future<void> _refresh(BuildContext context) async {
    final auth = context.watch<Auth>();
    if (auth.currentMember.schoolId != null) {
      final School school =
          context.watch<Schools>().findById(auth.currentMember.schoolId);
      await Provider.of<Books>(context, listen: false)
          .fetchAndSetBooks(auth, school);
    } else
      await Provider.of<Books>(context, listen: false)
          .fetchAndSetBooks(auth, null);
  }

  List<Book> loadBooks(BuildContext context) {
    final booksData = Provider.of<Books>(context, listen: false);
    if (isSearching)
      return booksData.findBooksByName(searchText);
    else
      return booksData.books;
  }

  @override
  Widget build(BuildContext context) {
    List<Book> books = loadBooks(context);

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: books.isNotEmpty
          ? BookList(books)
          : FutureBuilder(
              future: _refresh(context),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  return Center(child: Text('An Error occured'));
                } else {
                  print('Going through FutureBuilder');
                  return BookList(loadBooks(context));
                }
              },
            ),
    );
  }
}

class BookList extends StatelessWidget {
  final List<Book> books;
  BookList(this.books);

  @override
  Widget build(BuildContext context) {
    // return Consumer<Books>(builder: (ctx, allItems, _) {
    //   final books = allItems.books;
    print("booklist : " + books.length.toString());

    return ListView.builder(
      itemCount: books.length,
      // itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
      //   value: books[i],
      //   child: BookItem(),
      // ),
      itemBuilder: (ctx, i) => BookItem(books[i]),
    );
    //});
  }
}
