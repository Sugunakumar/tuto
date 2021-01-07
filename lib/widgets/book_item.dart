import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/user.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/edit_book.dart';

import '../screens/chapters.dart';
import '../providers/chapters.dart';
import '../providers/cart.dart';
import './../models/book.dart';

class BookItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final book = Provider.of<Book>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final bool access = Provider.of<Auth>(context, listen: false)
        .hasAccess(Entity.Book, Operations.Add);
    print("hasAccess : " + access.toString());

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              BookDetailScreen.routeName,
              arguments: book.id,
            );
          },
          child: Image.network(
            book.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Book>(
            builder: (ctx, book, _) => IconButton(
              icon: Icon(
                book.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                book.toggleFavoriteStatus(authData.currentUser.id);
              },
            ),
          ),
          title: Text(
            book.title,
            textAlign: TextAlign.center,
          ),
          trailing: authData.hasAccess(Entity.Book, Operations.Update)
              ? IconButton(
                  icon: Icon(
                    Icons.edit,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditBookScreen.routeName,
                        arguments: book.id);
                    // Scaffold.of(context).hideCurrentSnackBar();
                    // Scaffold.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       'Added item to cart!',
                    //     ),
                    //     duration: Duration(seconds: 2),
                    //     action: SnackBarAction(
                    //       label: 'UNDO',
                    //       onPressed: () {
                    //         cart.removeSingleItem(book.id);
                    //       },
                    //     ),
                    //   ),
                  },
                  color: Theme.of(context).accentColor,
                )
              : Container(),
        ),
      ),
    );
  }
}
