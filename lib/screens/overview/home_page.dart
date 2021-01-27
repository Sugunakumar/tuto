import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/screens/edit/edit_book.dart';
import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/widgets/app_drawer.dart';
import 'package:tuto/widgets/books_list.dart';

import 'package:tuto/widgets/school_list.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/school-detail';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    //final schoolId = ModalRoute.of(context).settings.arguments as String;
    //print("schoolId : " + schoolId);

    final authData = Provider.of<Auth>(context, listen: false);
    //final schoolsData = Provider.of<Schools>(context, listen: false);

    //final loadedSchool = schoolsData.findById(schoolId);

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(child: Text("Schools")),
                Tab(child: Text("Books")),
              ],
            ),
            title: Text('WorkBook'),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  print('search clicked');
                },
              ),
              PopupMenuButton(
                onSelected: (String selectedValue) {
                  setState(() {
                    print(selectedValue);
                  });
                },
                icon: Icon(
                  Icons.more_vert,
                ),
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text('Profile'),
                    value: 'one',
                  ),
                  PopupMenuItem(
                    child: Text('Sign Out'),
                    value: 'two',
                  ),
                ],
              ),
            ],
          ),
          drawer: AppDrawer(),
          body: TabBarView(
            controller: _tabController,
            children: [
              SchoolListTab(),
              BookListTab(),
              //TabList(),
            ],
          ),
          floatingActionButton: _bottomButtons(),
        ),
      ),
    );
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
