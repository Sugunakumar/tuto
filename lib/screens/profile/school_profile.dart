import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/models/user.dart';
import 'package:tuto/providers/auth.dart';

import '../../screens/edit/edit_class.dart';
import '../../screens/edit/edit_school.dart';

import '../../models/school.dart';
import '../../providers/classes.dart';
import '../../providers/schools.dart';
import '../../providers/tasks.dart';
import '../../providers/teachers.dart';
import '../../widgets/classes_list.dart';
import '../../widgets/teachers_list.dart';

School loadedSchool;
Schools schoolsData;
Classes classesData;
Teachers teachersData;
Tasks tasksData;
Auth authProvider;

class SchoolProfile extends StatefulWidget {
  static const routeName = '/school-profile';

  @override
  _SchoolProfileState createState() => _SchoolProfileState();
}

class _SchoolProfileState extends State<SchoolProfile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    super.initState();
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
    final schoolId = ModalRoute.of(context).settings.arguments as String;
    print("schoolId : " + schoolId);

    schoolsData = Provider.of<Schools>(context, listen: false);
    loadedSchool = schoolsData.findById(schoolId);
    authProvider = Provider.of<Auth>(context, listen: false);
    classesData = Provider.of<Classes>(context);
    classesData.schoolId = schoolId;
    teachersData = Provider.of<Teachers>(context);
    tasksData = Provider.of<Tasks>(context, listen: false);

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(child: Text("Teachers")),
                Tab(child: Text("Classes")),
              ],
            ),
            title: Text(loadedSchool.name),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditSchoolScreen.routeName,
                      arguments: schoolId);
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.delete),
              //   onPressed: () async {
              //     try {
              //       await schoolsData.delete(schoolId);
              //       Navigator.of(context).pop();
              //       Scaffold.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(
              //             'School deleted',
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //       );
              //     } catch (e) {
              //       Scaffold.of(context).showSnackBar(
              //         SnackBar(
              //           content: Text(
              //             'Deleting Failed',
              //             textAlign: TextAlign.center,
              //           ),
              //         ),
              //       );
              //     }
              //   },
              //   color: Theme.of(context).errorColor,
              // ),
            ],
          ),

          //backgroundColor: Colors.grey.shade300,
          //body: getPage(_currentPage),
          body: TabBarView(
            controller: _tabController,
            children: [
              TeachersTab(),
              ClassesTab(),
              //TabList(),
            ],
          ),
          //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: _bottomButtons(),
          // bottomNavigationBar: AnimatedBottomNav(
          //     currentIndex: _currentPage,
          //     onChange: (index) {
          //       setState(() {
          //         _currentPage = index;
          //       });
          //     }),
        ),
      ),
    );
  }

  getPage(int page) {
    switch (page) {
      case 0:
        return ProfileTab();
      case 1:
        return TeachersTab();
      case 2:
        return ClassesTab();
    }
  }

  Future<void> addTeacherByEmailDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (ctx) {
          return AddDialogWidget();
        });
  }

  Widget _bottomButtons() {
    if (_tabController.index == 0) {
      return FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () async {
            await addTeacherByEmailDialog(context);
            //Navigator.of(context).pushNamed(EditTeacherScreen.routeName),
          },
          child: Icon(
            Icons.add,
          ));
    } else if (_tabController.index == 1) {
      return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () => {
          Navigator.of(context).pushNamed(EditClassScreen.routeName),
        },
        child: Icon(
          Icons.add,
        ),
      );
    } else
      return null;
  }
}

class AddDialogWidget extends StatefulWidget {
  AddDialogWidget({
    Key key,
  }) : super(key: key);

  @override
  _AddDialogWidgetState createState() => _AddDialogWidgetState();
}

class _AddDialogWidgetState extends State<AddDialogWidget> {
  final _form = GlobalKey<FormState>();

  var _isLoading = false;
  var _teacherEmail = '';
  var _isAdmin = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    try {
      print("_teacherEmail : " +
          _teacherEmail +
          '  isAdmin : ' +
          _isAdmin.toString());

      CurrentUser addedUser =
          await authProvider.fetchUserByEmail(_teacherEmail);
      await teachersData.add(addedUser);
      //await loadedSchool.addTeacher(addedUser);
    } catch (e) {
      await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occured!'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                    child: Text('Okay'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ));
    }
    //  finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   Navigator.of(context).pop();
    // }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : AlertDialog(
            title: Text('Add Teacher'),
            content: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autocorrect: false,
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      _saveForm();
                    },
                    validator: (value) {
                      if (value.trim().isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _teacherEmail = value;
                    },
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text("Is Admin ?"),
                  //     Checkbox(
                  //         value: _isAdmin,
                  //         onChanged: (checked) {
                  //           setState(() {
                  //             _isAdmin = checked;
                  //           });
                  //         })
                  //   ],
                  // )
                ],
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('Add'),
                onPressed: () {
                  _saveForm();
                },
              )
            ],
          );
  }
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 250,
            width: double.infinity,
            child: FittedBox(
              child: Image.network(
                loadedSchool.imageURL,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 16.0),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.only(top: 16.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(left: 96.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(loadedSchool.name,
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                ListTile(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(loadedSchool.board),
                                  subtitle: Text(loadedSchool.address),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text("285"),
                                    Text("Likes")
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text("3025"),
                                    Text("Comments")
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text("650"),
                                    Text("Favourites")
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                              image: NetworkImage(loadedSchool.imageURL),
                              fit: BoxFit.cover)),
                      margin: EdgeInsets.only(left: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                //ProfileCategories(),
                //SchoolEntity(),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("User information"),
                      ),
                      Divider(),
                      ListTile(
                        title: Text("Email"),
                        subtitle: Text("butterfly.little@gmail.com"),
                        leading: Icon(Icons.email),
                      ),
                      ListTile(
                        title: Text("Phone"),
                        subtitle: Text("+977-9815225566"),
                        leading: Icon(Icons.phone),
                      ),
                      ListTile(
                        title: Text("Website"),
                        subtitle: Text("https://www.littlebutterfly.com"),
                        leading: Icon(Icons.web),
                      ),
                      ListTile(
                        title: Text("About"),
                        subtitle: Text(
                            "Lorem ipsum, dolor sit amet consectetur adipisicing elit. Nulla, illo repellendus quas beatae reprehenderit nemo, debitis explicabo officiis sit aut obcaecati iusto porro? Exercitationem illum consequuntur magnam eveniet delectus ab."),
                        leading: Icon(Icons.person),
                      ),
                      ListTile(
                        title: Text("Joined Date"),
                        subtitle: Text("15 February 2019"),
                        leading: Icon(Icons.calendar_view_day),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // AppBar(
          //   backgroundColor: Colors.transparent,
          //   elevation: 0,
          // )
        ],
      ),
    );
  }
}

class ClassesTab extends StatelessWidget {
  const ClassesTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return classesData.items.isEmpty
        ? FutureBuilder(
            future: classesData.fetchAndSet(),
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (dataSnapshot.error != null) {
                // Error handling
                print(dataSnapshot.error.toString());
                return Center(child: Text('An Error occured'));
              } else {
                return ClassesList(entityItems: classesData.items);
              }
            })
        : ClassesList(entityItems: classesData.items);
  }
}

class TeachersTab extends StatelessWidget {
  const TeachersTab({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<void> _refresh(BuildContext context) async {
      await teachersData.fetchAndSet(loadedSchool.id);
    }

    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: teachersData.items.isEmpty
          ? FutureBuilder(
              future: _refresh(context),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  print(dataSnapshot.error.toString());
                  return Center(child: Text('An Error occured'));
                } else {
                  return TeachersList();
                }
              })
          : TeachersList(),
    );
  }
}

class AnimatedBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChange;
  const AnimatedBottomNav({Key key, this.currentIndex, this.onChange})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        children: <Widget>[
          // Expanded(
          //   child: InkWell(
          //     onTap: () => onChange(0),
          //     child: BottomNavItem(
          //       icon: Icons.home,
          //       title: "Profile",
          //       isActive: currentIndex == 0,
          //     ),
          //   ),
          // ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(1),
              child: BottomNavItem(
                icon: Icons.group,
                title: "Teachers",
                isActive: currentIndex == 1,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onChange(2),
              child: BottomNavItem(
                icon: Icons.book,
                title: "Classes",
                isActive: currentIndex == 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final bool isActive;
  final IconData icon;
  final Color activeColor;
  final Color inactiveColor;
  final String title;
  const BottomNavItem(
      {Key key,
      this.isActive = false,
      this.icon,
      this.activeColor,
      this.inactiveColor,
      this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        transitionBuilder: (child, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        duration: Duration(milliseconds: 500),
        reverseDuration: Duration(milliseconds: 200),
        child: isActive
            ? Container(
                color: Colors.white,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: activeColor ?? Theme.of(context).primaryColor,
                        ),
                        Text(
                          ' ' + title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                activeColor ?? Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: 5.0,
                      height: 5.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeColor ?? Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              )
            : Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: inactiveColor ?? Colors.grey,
                  ),
                  Text(' ' + title,
                      style: TextStyle(color: inactiveColor ?? Colors.grey)),
                ],
              ));
  }
}
