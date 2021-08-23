import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/common/utils.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';
import 'package:tuto/new_providers/chapter.dart';

import 'package:tuto/new_providers/classBook.dart';
import 'package:tuto/widgets/item/chapter_item.dart';
import 'package:tuto/widgets/list/books_list.dart';

import '../../data/constants.dart';
import '../../providers/auth.dart';
import '../edit/edit_chapter.dart';

class BookProfile extends StatefulWidget {
  static const routeName = '/book-profile';
  static String bookId;

  @override
  _BookProfileState createState() => _BookProfileState();
}

class _BookProfileState extends State<BookProfile>
    with SingleTickerProviderStateMixin {
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  bool _isSearching;
  String _searchText = "";
  Widget appBarTitle;

  final TextEditingController _searchQuery = new TextEditingController();

  _BookProfileState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  @override
  void initState() {
    _isSearching = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildBar(BuildContext context, String title) {
    return new AppBar(
      title: appBarTitle != null ? appBarTitle : new Text(title),
      actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                appBarTitle = new TextField(
                  controller: _searchQuery,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd(title);
              }
            });
          },
        ),
        // IconButton(
        //   icon: const Icon(Icons.edit),
        //   onPressed: () {
        //     // Navigator.of(context).pushNamed(EditSchoolScreen.routeName,
        //     //     arguments: loadedSchool.id);
        //   },
        // ),
      ],
    );
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd(String title) {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(title);
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _bottomButtons() {
    return FloatingActionButton(
      shape: StadiumBorder(),
      onPressed: () {
        print(' add chapters');
        Navigator.of(context).pushNamed(EditChapterScreen.routeName);
      },
      child: Icon(
        Icons.add,
      ),
    );
  }

  Future<void> _refreshAllChapters(
      BuildContext context, Book loadedBook) async {
    await loadedBook.fetchAndSetChapters();
  }

  Future<void> _refreshClassBookChapters(
      BuildContext context, Book loaddedBook) async {
    if (loaddedBook.chapters == null) {
      await _refreshAllChapters(context, loaddedBook);
    }

    if (BookListTab.clazzStatic != null) {
      ClassBook classBook =
          BookListTab.clazzStatic.findClassBookById(loaddedBook.id);

      if (classBook.classChapters == null) {
        await classBook.fetchAndSetChapters();
      }
    }
  }

  List<Chapter> loadChapters(BuildContext context, Book book) {
    print('loadChapters');
    // Load full chapters of the full book
    List<Chapter> chaps = book.chapters;

    print('chaps ' + chaps.toString());
    // Load limited chapters from the class book
    if (BookListTab.clazzStatic != null) {
      var classChaps =
          BookListTab.clazzStatic?.findClassBookById(book.id)?.classChapters;
      if (classChaps != null) {
        chaps = classChapterToFullChapter(classChaps, chaps);
      } else
        return null;
    }

    if (chaps == null) {
      return null;
    }
    // print('isSearching book profile: ' + _isSearching.toString());
    // print('searchText : ' + _searchText.toString());
    // print('chaps.length : ' + chaps.length.toString());

    if (_isSearching)
      return chaps
          .where(
              (s) => s.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    else
      return chaps;
  }

  @override
  Widget build(BuildContext context) {
    final bookId = ModalRoute.of(context).settings.arguments as String;
    if (bookId == null) print("book id is null");

    BookProfile.bookId = bookId;

    final auth = Provider.of<Auth>(context, listen: false);

    Book loadedFullBook = context.watch<Books>().findBookById(bookId);
    //ClassBook loadedClassBook = BookListTab.clazzStatic.findClassBookById(bookId);

    return Scaffold(
      appBar: buildBar(context, loadedFullBook.title),
      body: RefreshIndicator(
        onRefresh: () => _refreshClassBookChapters(context, loadedFullBook),
        child: loadChapters(context, loadedFullBook) ==
                null // Chapters are not loaded
            ? FutureBuilder(
                future: _refreshClassBookChapters(
                    context, loadedFullBook), // load the limited chapters
                builder: (ctx, dataSnapshot) {
                  if (dataSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (dataSnapshot.error != null) {
                    // Error handling
                    return Center(child: Text('An Error occured Book Profile'));
                  } else {
                    print('Going through FutureBuilder book profile');
                    return ChapterList(loadChapters(context,
                        loadedFullBook)); // Get and Show only limited chapters
                  }
                },
              )
            : ChapterList(loadChapters(
                context, loadedFullBook)), // Get and Show only limited chapters
      ),
      floatingActionButton: auth.currentMember.roles.contains(Role.SchoolAdmin)
          ? _bottomButtons()
          : null,
    );
  }
}

class ChapterList extends StatelessWidget {
  final List<Chapter> chapters;
  ChapterList(this.chapters);

  @override
  Widget build(BuildContext context) {
    print("chapters list : " + chapters.length.toString());
    return ListView.builder(
      itemCount: chapters.length,
      itemBuilder: (ctx, i) => ChapterItem(chapters[i]),
    );
  }
}
