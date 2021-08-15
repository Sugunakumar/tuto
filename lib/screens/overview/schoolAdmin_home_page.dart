import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/screens/edit/edit_book.dart';
import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/widgets/app_drawer.dart';
import 'package:tuto/widgets/list/books_list.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/widgets/item/school_item.dart';
import 'package:tuto/widgets/list/school_list.dart';
import 'package:tuto/providers/auth.dart';

enum FilterOptions {
  Favorites,
  All,
}

class SchoolScreen extends StatefulWidget {
  static const routeName = '/school-detail';

  @override
  _SchoolScreenState createState() => _SchoolScreenState();
}

class _SchoolScreenState extends State<SchoolScreen>
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

  _SchoolScreenState() {
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
    //final bool isAdmin = context.watch<Auth>().isAdmin();
    final auth = context.watch<Auth>();
    final schoolId = ModalRoute.of(context).settings.arguments as String;

    //final bool hasAccess = auth.hasAccess(Entity.School, Operations.View);

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildBar(context, auth),
          drawer: AppDrawer(),
          body: TabBarView(
            controller: _tabController,
            children: [
              SchoolListTab(_isSearching, _searchText),
              BookListTab(_isSearching, _searchText),
              //TabList(),
            ],
          ),
          floatingActionButton: _bottomButtons(auth),
        ),
      ),
    );
  }

  Widget buildBar(BuildContext context, Auth auth) {
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
        // PopupMenuButton(
        //   onSelected: (FilterOptions selectedValue) {
        //     setState(() {
        //       if (selectedValue == FilterOptions.Favorites) {
        //         _showOnlyFavorites = true;
        //         print("Show only Favorites");
        //       } else {
        //         _showOnlyFavorites = false;
        //         print("Show All");
        //       }
        //     });
        //   },
        //   icon: Icon(
        //     Icons.filter_list,
        //   ),
        //   itemBuilder: (_) => [
        //     PopupMenuItem(
        //       child: Text('Only Favorites'),
        //       value: FilterOptions.Favorites,
        //     ),
        //     PopupMenuItem(
        //       child: Text('Show All'),
        //       value: FilterOptions.All,
        //     ),
        //   ],
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

  Widget _bottomButtons(Auth auth) {
    return _tabController.index == 0
        //? auth.hasAccess(Entity.School, Operations.Add)
        // school
        ? auth.isAdmin()
            ? FloatingActionButton(
                shape: StadiumBorder(),
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditSchoolScreen.routeName),
                child: Icon(
                  Icons.add,
                ))
            : null
        // books
        : auth.currentMember.roles.contains(Role.SchoolAdmin)
            ? FloatingActionButton(
                shape: StadiumBorder(),
                onPressed: () =>
                    Navigator.of(context).pushNamed(EditBookScreen.routeName),
                child: Icon(
                  Icons.add,
                ),
              )
            : null;
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
