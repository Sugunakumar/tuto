import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/models.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/class.dart';

import 'package:tuto/screens/profile/book_profile.dart';

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
                // style: const TextStyle(
                //   fontSize: 13.0,
                //   color: Colors.black54,
                // ),
              ),
              Text(
                '$author',
                // style: const TextStyle(
                //   fontSize: 12.0,
                //   //color: Colors.black87,
                // ),
              ),
              Text(
                '$publishDate - $readDuration',
                // style: const TextStyle(
                //   fontSize: 12.0,
                //   //color: Colors.black54,
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  final Book book;

  CustomListItemTwo(
    this.book, {
    Key key,
  }) : super(key: key);

  // final String id;
  // final Widget thumbnail;
  // final String title;
  // final String subtitle;
  // final String author;
  // final String publishDate;
  // final String readDuration;

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
            
            Navigator.of(context).pushNamed(BookProfile.routeName, arguments: book.id);
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
                  child: Container(
                    child: FittedBox(
                      child: Image.network(
                        book.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleDescription(
                      title: book.title,
                      subtitle: book.subject,
                      author: book.pages.toString(),
                      publishDate: book.editor,
                      readDuration: book.publisher,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Theme.of(context).buttonColor,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final Book book;
  BookItem(this.book, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final authData = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CustomListItemTwo(book),
      //  Consumer<Book>(
      //   builder: (ctx, book, _) => CustomListItemTwo(book),
      //),
    );
  }
}

// id: book.id,
// thumbnail:
// title: book.title,
// subtitle: book.subject,
// author: book.pages.toString(),
// publishDate: book.editor,
// readDuration: book.publisher,
