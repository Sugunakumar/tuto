import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/models/book.dart';

import 'package:tuto/providers/auth.dart';
import 'package:tuto/providers/books.dart';
import 'package:tuto/screens/overview/book_chapters.dart';

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$subtitle',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            //crossAxisAlignment: CrossAxisAlignment.end, // top to bottom
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // left to right
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // left to right
                mainAxisAlignment: MainAxisAlignment.end, // top to bottom
                children: <Widget>[
                  Text(
                    '$author',
                    style: const TextStyle(
                      fontSize: 12.0,
                      //color: Colors.black87,
                    ),
                  ),
                  Text(
                    '$publishDate - $readDuration',
                    style: const TextStyle(
                      fontSize: 12.0,
                      //color: Colors.black54,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      print('edit was clicked');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.id,
    this.thumbnail,
    this.title,
    this.subtitle,
    this.author,
    this.publishDate,
    this.readDuration,
  }) : super(key: key);

  final String id;
  final Widget thumbnail;
  final String title;
  final String subtitle;
  final String author;
  final String publishDate;
  final String readDuration;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: InkWell(
          onTap: () {
            print('Book was tapped');
           Navigator.of(context)
                .pushNamed(BookDetailScreen.routeName, arguments: id);
          },
          // Generally, material cards use onSurface with 12% opacity for the pressed state.
          splashColor:
              Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
          // Generally, material cards do not have a highlight overlay.
          highlightColor: Colors.transparent,
          child: SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.0,
                  child: thumbnail,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleDescription(
                      title: title,
                      subtitle: subtitle,
                      author: author,
                      publishDate: publishDate,
                      readDuration: readDuration,
                    ),
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.more_vert),
                //   onPressed: () {},
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class BookListTab extends StatelessWidget {
  BookListTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    final booksData = Provider.of<Books>(context, listen: false);

    return booksData.items.isNotEmpty
        ? BookList()
        : FutureBuilder(
            future: booksData.fetchAndSetBooks(authData.currentUser.id),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataSnapshot.error != null) {
                // Error handling
                return Center(child: Text('An Error occured'));
              } else {
                return BookList();
              }
            },
          );
  }
}

class BookList extends StatelessWidget {
  BookList();

  @override
  Widget build(BuildContext context) {
    return Consumer<Books>(builder: (ctx, allItems, _) {
      final books = allItems.items;
      print("booklist : " + books.length.toString());

      return ListView.builder(
        itemCount: books.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: books[i],
          child: BookItem(),
        ),
      );
    });
  }
}

class BookItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authData = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Consumer<Book>(
        builder: (ctx, book, _) => CustomListItemTwo(
          id: book.id,
          thumbnail: Container(
            child: FittedBox(
              child: Image.network(
                book.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          title: book.title,
          subtitle: book.subject,
          author: book.pages.toString(),
          publishDate: book.editor,
          readDuration: book.publisher,
        ),
      ),
    );
  }
}
