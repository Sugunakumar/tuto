import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';

import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/edit/edit_schoolTeacher.dart';
import 'package:tuto/widgets/list/teachers_list.dart';

import '../../widgets/list/classes_list.dart';

School _loadedSchool;

class SchoolProfile extends StatefulWidget {
  static const routeName = '/school-profile';
  static String schoolId;

  @override
  _SchoolProfileState createState() => _SchoolProfileState();
}

class _SchoolProfileState extends State<SchoolProfile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text("WorkBook");
  bool _isSearching;
  String _searchText = "";

  final TextEditingController _searchQuery = new TextEditingController();

  _SchoolProfileState() {
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
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    _isSearching = false;
    super.initState();
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
    final schoolId = ModalRoute.of(context).settings.arguments as String;
    SchoolProfile.schoolId = schoolId;
    print("schoolId : " + schoolId);

    _loadedSchool = context.watch<Schools>().findById(schoolId);
    print("loadedSchool.name : " + _loadedSchool.name);

    final auth = Provider.of<Auth>(context, listen: false);
    // await auth.fetchAndSetMembers();

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildBar(context),
          body: TabBarView(
            controller: _tabController,
            children: [
              TeachersTab(_loadedSchool, _isSearching, _searchText),
              ClassesTab(_loadedSchool, _isSearching, _searchText),
            ],
          ),
          floatingActionButton: _bottomButtons(auth),
        ),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
      title: appBarTitle,
      centerTitle: true,
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
        //   icon: const Icon(Icons.edit),
        //   onPressed: () {
        //     Navigator.of(context).pushNamed(EditSchoolScreen.routeName,
        //         arguments: _loadedSchool.id);
        //   },
        // ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(child: Text("Teachers")),
          Tab(child: Text("Classes")),
        ],
      ),
    );
  }

  // Future<void> addTeacherByEmailDialog(BuildContext context) async {
  //   await showDialog(
  //       context: context,
  //       builder: (ctx) {
  //         return AddDialogWidget();
  //       });
  // }

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
      this.appBarTitle = new Text(_loadedSchool.name);
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _bottomButtons(Auth auth) {
    if (_tabController.index == 1) {
      return auth.currentMember.roles.contains(Role.SchoolAdmin)
          ? FloatingActionButton(
              shape: StadiumBorder(),
              onPressed: () {
                Navigator.of(context).pushNamed(EditClassScreen.routeName);
              },
              child: Icon(
                Icons.add,
              ),
            )
          : null;
    } else if (_tabController.index == 0) {
      return auth.currentMember.roles.contains(Role.SchoolAdmin)
          ? FloatingActionButton(
              shape: StadiumBorder(),
              onPressed: () {
                print('floating action button');
                //await addTeacherByEmailDialog(context);
                Navigator.of(context)
                    .pushNamed(EditSchoolTeacherScreen.routeName);
              },
              child: Icon(Icons.add),
            )
          : null;
    } else
      return null;
  }
}

// class AddDialogWidget extends StatefulWidget {
//   AddDialogWidget({
//     Key key,
//   }) : super(key: key);

//   @override
//   _AddDialogWidgetState createState() => _AddDialogWidgetState();
// }

// class _AddDialogWidgetState extends State<AddDialogWidget> {
//   final _form = GlobalKey<FormState>();
//   bool _isAdmin = false;
//   var _isLoading = false;
//   var _teacherEmail = '';

//   Future<void> _saveForm() async {
//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       Member addedUser = await auth.fetchUserByEmail(_teacherEmail);
//       if (addedUser != null)
//         await context.read<SchoolNotifier>().addTeacher(addedUser, _isAdmin);
//       else
//         throw Exception("No such user");
//       //await schoolData.addTeacher(addedUser);
//       //await loadedSchool.addTeacher(addedUser);
//     } catch (e) {
//       await showDialog<Null>(
//           context: context,
//           builder: (ctx) => AlertDialog(
//                 title: Text('Could not add user'),
//                 content: Text('No such user. Please enter the valid email.'),
//                 actions: [
//                   FlatButton(
//                     child: Text('Okay'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   )
//                 ],
//               ));
//     }
//     //  finally {
//     //   setState(() {
//     //     _isLoading = false;
//     //   });
//     //   Navigator.of(context).pop();
//     // }

//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//   }

//   @override
//   Widget build(BuildContext context) {
//     //final bool isAdmin = context.watch<Auth>().isAdmin();
//     final auth = context.watch<Auth>();

//     return _isLoading
//         ? Center(
//             child: CircularProgressIndicator(),
//           )
//         : AlertDialog(
//             title: Text('Add Teacher'),
//             content: Form(
//               key: _form,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   TextFormField(
//                     autocorrect: false,
//                     decoration: InputDecoration(labelText: 'Email'),
//                     keyboardType: TextInputType.emailAddress,
//                     textInputAction: TextInputAction.done,
//                     onFieldSubmitted: (_) {
//                       _saveForm();
//                     },
//                     validator: (value) {
//                       if (value.trim().isEmpty || !value.contains('@')) {
//                         return 'Please enter a valid email address.';
//                       }
//                       return null;
//                     },
//                     onSaved: (value) {
//                       _teacherEmail = value;
//                     },
//                   ),
//                   auth.hasAccess(Entity.Teacher, Operations.AddSchoolAdmin)
//                       ? Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text("Is Admin ?"),
//                             Checkbox(
//                                 value: _isAdmin,
//                                 onChanged: (checked) {
//                                   setState(() {
//                                     _isAdmin = checked;
//                                     print('_isAdmin  ' + _isAdmin.toString());
//                                   });
//                                 })
//                           ],
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//             actions: [
//               FlatButton(
//                 child: Text('Cancel'),
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//               FlatButton(
//                 child: Text('Add'),
//                 onPressed: () {
//                   _saveForm();
//                 },
//               )
//             ],
//           );
//   }
// }

// class TeachersTab extends StatelessWidget {
//   const TeachersTab({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     Future<void> _refresh(BuildContext context) async {
//       await schoolData.fetchAndSetTeachers();
//     }

//     return RefreshIndicator(
//       onRefresh: () => _refresh(context),
//       child: schoolData.teachers.isEmpty
//           ? FutureBuilder(
//               future: _refresh(context),
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (dataSnapshot.error != null) {
//                   // Error handling
//                   print(dataSnapshot.error.toString());
//                   return Center(child: Text('An Error occured'));
//                 } else {
//                   return TeachersList();
//                 }
//               })
//           : TeachersList(),
//     );
//   }
// }

// class AnimatedBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onChange;
//   const AnimatedBottomNav({Key key, this.currentIndex, this.onChange})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: kToolbarHeight,
//       decoration: BoxDecoration(color: Colors.white),
//       child: Row(
//         children: <Widget>[
//           // Expanded(
//           //   child: InkWell(
//           //     onTap: () => onChange(0),
//           //     child: BottomNavItem(
//           //       icon: Icons.home,
//           //       title: "Profile",
//           //       isActive: currentIndex == 0,
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange(1),
//               child: BottomNavItem(
//                 icon: Icons.group,
//                 title: "Teachers",
//                 isActive: currentIndex == 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange(2),
//               child: BottomNavItem(
//                 icon: Icons.book,
//                 title: "Classes",
//                 isActive: currentIndex == 2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomNavItem extends StatelessWidget {
//   final bool isActive;
//   final IconData icon;
//   final Color activeColor;
//   final Color inactiveColor;
//   final String title;
//   const BottomNavItem(
//       {Key key,
//       this.isActive = false,
//       this.icon,
//       this.activeColor,
//       this.inactiveColor,
//       this.title})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//         transitionBuilder: (child, animation) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0.0, 1.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//         duration: Duration(milliseconds: 500),
//         reverseDuration: Duration(milliseconds: 200),
//         child: isActive
//             ? Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Wrap(
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: [
//                         Icon(
//                           icon,
//                           color: activeColor ?? Theme.of(context).primaryColor,
//                         ),
//                         Text(
//                           ' ' + title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color:
//                                 activeColor ?? Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5.0),
//                     Container(
//                       width: 5.0,
//                       height: 5.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: activeColor ?? Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   Icon(
//                     icon,
//                     color: inactiveColor ?? Colors.grey,
//                   ),
//                   Text(' ' + title,
//                       style: TextStyle(color: inactiveColor ?? Colors.grey)),
//                 ],
//               ));
//   }
// }
