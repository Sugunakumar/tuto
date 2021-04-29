import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/screens/edit/edit_book.dart';
import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/widgets/app_drawer.dart';
import 'package:tuto/widgets/list/books_list.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/widgets/item/school_item.dart';
import 'package:tuto/widgets/list/school_list.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/school-detail';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool _isSearching;
  String _searchText = "";
  Widget appBarTitle = new Text(
    "WorkBook",
    //style: new TextStyle(color: Colors.white),
  );
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  final TextEditingController _searchQuery = new TextEditingController();

  _HomeScreenState() {
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
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _isSearching = false;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {
      if (_tabController.indexIsChanging) {
        _handleSearchEnd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildBar(context),
          drawer: AppDrawer(),
          body: TabBarView(
            controller: _tabController,
            children: [
              SchoolListTab(_isSearching, _searchText),
              BookListTab(_isSearching, _searchText),
              //TabList(),
            ],
          ),
          floatingActionButton: _bottomButtons(),
        ),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(child: Text("Schools")),
          Tab(child: Text("Books")),
        ],
      ),
      centerTitle: true,
      title: appBarTitle,
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
                this.appBarTitle = new TextField(
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
                _handleSearchEnd();
              }
            });
          },
        ),

        // IconButton(
        //   icon: const Icon(Icons.search),
        //   onPressed: () {
        //     if (_tabController.index == 0)
        //       print('search clicked for school');
        //     else
        //       print('search clicked for books');
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

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text("WorkBook");
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _bottomButtons() {
    return _tabController.index == 0
        ? FloatingActionButton(
            shape: StadiumBorder(),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditSchoolScreen.routeName),
            child: Icon(
              Icons.add,
            ))
        : FloatingActionButton(
            shape: StadiumBorder(),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditBookScreen.routeName),
            child: Icon(
              Icons.add,
            ),
          );
  }
}

// PopupMenuButton(
//   onSelected: (String selectedValue) {
//     setState(() {
//       print(selectedValue);
//       if (selectedValue == 'signout')
//         FirebaseAuth.instance.signOut();
//     });
//   },
//   icon: Icon(
//     Icons.more_vert,
//   ),
//   itemBuilder: (_) => [
//     PopupMenuItem(
//       child: Text('Profile'),
//       value: 'profile',
//     ),
//     PopupMenuItem(
//       child: Text('Sign Out'),
//       value: 'signout',
//     ),
//   ],
// ),
