import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/books.dart';
import 'book_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    // final booksData = Provider.of<Books>(context);
    //final books = showFavs ? booksData.favoriteItems : booksData.items;
    return Consumer<Books>(builder: (ctx, allBooks, _) {
      final books = showFavs ? allBooks.favoriteItems : allBooks.items;
      // return SliverPadding(
      //   padding: const EdgeInsets.all(16.0),
      //   sliver: SliverGrid(
      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //         mainAxisSpacing: 10.0,
      //         crossAxisSpacing: 10.0,
      //         childAspectRatio: 1.0,
      //         crossAxisCount: 2),

      //     // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     //     crossAxisCount: MediaQuery.of(context).size.width >
      //     //             1000
      //     //         ? 7
      //     //         : MediaQuery.of(context).size.width > 600 ? 5 : 3,
      //     //     childAspectRatio: 1.2,
      //     //     crossAxisSpacing: 10.0,
      //     //     mainAxisSpacing: 10.0)
      //     delegate: SliverChildBuilderDelegate(
      //       (ctx, i) => ChangeNotifierProvider.value(
      //         // builder: (c) => books[i],
      //         value: books[i],
      //         child: BookItem(
      //             // books[i].id,
      //             // books[i].title,
      //             // books[i].imageUrl,
      //             ),
      //       ),
      //       childCount: books.length,
      //     ),
      //   ),
      // );

      return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: books.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          // builder: (c) => books[i],
          value: books[i],
          child: BookItem(
              // books[i].id,
              // books[i].title,
              // books[i].imageUrl,
              ),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      );
    });
  }
}
