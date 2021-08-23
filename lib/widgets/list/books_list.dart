import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/common/utils.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';
import 'package:tuto/new_providers/class.dart';

import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/widgets/item/book_item.dart';

class BookListTab extends StatelessWidget {
  static Class clazzStatic;

  final bool isSearching;
  final String searchText;
  final Class clazz;

  BookListTab(this.isSearching, this.searchText, {this.clazz, Key key})
      : super(key: key);

  Future<void> _refreshAll(BuildContext context) async {
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

  Future<void> _refreshClassBooks(BuildContext context) async {
    if (context.watch<Books>().books == null) await _refreshAll(context);

    if (clazz != null) {
      if (clazz?.books == null) {
        print('postive ');
        await clazz.fetchAndSetClassBooks();
      }
    }
  }

  List<Book> loadBooks(BuildContext context) {
    var _books = context.watch<Books>().books;

    if (clazz != null) {
      if (clazz.books != null) {
        print('Full books' + _books.length.toString());
        print('Class books' + clazz.books.length.toString());
        _books = classBookToFullBook(clazz.books, _books);
      } else
        return null;
    }

    if (_books == null) {
      return null;
    }

    print('isSearching booklist : ' + isSearching.toString());
    print('searchText : ' + searchText.toString());

    if (isSearching)
      return _books
          .where(
              (s) => s.title.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    else
      return _books;
  }

  @override
  Widget build(BuildContext context) {
    BookListTab.clazzStatic = clazz;

    return RefreshIndicator(
      onRefresh: () => _refreshClassBooks(context),
      child: loadBooks(context) == null
          ? FutureBuilder(
              future: _refreshClassBooks(context),
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
            )
          : BookList(loadBooks(context)),
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
