import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/screens/edit/edit_book.dart';
import 'package:tuto/screens/profile/school_profile.dart';
import 'package:tuto/widgets/list/books_list.dart';
import 'package:tuto/widgets/list/teachers_list.dart';

import '../../providers/auth.dart';

Class _loadedClass;

class ClassProfile extends StatefulWidget {
  static const routeName = '/class-profile';
  static String classId;

  @override
  _ClassProfileState createState() => _ClassProfileState();
}

class _ClassProfileState extends State<ClassProfile>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Icon actionIcon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  bool _isSearching;
  String _searchText = "";
  Widget appBarTitle = new Text("WorkBook");

  final TextEditingController _searchQuery = new TextEditingController();

  _ClassProfileState() {
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
    final classId = ModalRoute.of(context).settings.arguments as String;
    print("classId : " + classId);
    ClassProfile.classId = classId;

    _loadedClass = context
        .watch<Schools>()
        .findById(SchoolProfile.schoolId)
        .findClassById(classId);
    //loadedClass = Provider.of<ClassNotifier>(context, listen: false).clazz;
    print("loadedClass.name : " + _loadedClass.name);

    final auth = Provider.of<Auth>(context, listen: false);

    this.appBarTitle = new Text(
      _loadedClass.name,
      style: new TextStyle(color: Colors.white),
    );

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: buildBar(context),
          body: TabBarView(
            controller: _tabController,
            children: [
              BookListTab(_isSearching, _searchText),
              Center(
                child: Text('Students'),
              ),
            ],
          ),
          floatingActionButton: _bottomButtons(),
        ),
      ),
    );
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
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
                _handleSearchEnd();
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            // Navigator.of(context).pushNamed(EditSchoolScreen.routeName,
            //     arguments: loadedSchool.id);
          },
        ),
      ],
      bottom: TabBar(
        controller: _tabController,
        tabs: [
          Tab(child: Text("Books")),
          Tab(child: Text("Students")),
        ],
      ),
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
      this.appBarTitle = new Text(_loadedClass.name);
      _isSearching = false;
      _searchQuery.clear();
    });
  }

  Widget _bottomButtons() {
    if (_tabController.index == 0) {
      return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () {
          print('books & subjects');
          Navigator.of(context).pushNamed(EditBookScreen.routeName);
        },
        child: Icon(
          Icons.add,
        ),
      );
    } else if (_tabController.index == 1) {
      return FloatingActionButton(
          shape: StadiumBorder(),
          onPressed: () async {
            print('students');
            //await addTeacherByEmailDialog(context);
            //Navigator.of(context).pushNamed(EditTeacherScreen.routeName),
          },
          child: Icon(
            Icons.add,
          ));
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

//   var _isLoading = false;
//   var _teacherEmail = '';
//   var _isAdmin = false;

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
//       print("_teacherEmail : " +
//           _teacherEmail +
//           '  isAdmin : ' +
//           _isAdmin.toString());

//       Member addedUser = await authProvider.fetchUserByEmail(_teacherEmail);
//       //await loadedClass.addStudent(addedUser);
//       //await loadedSchool.addTeacher(addedUser);
//     } catch (e) {
//       await showDialog<Null>(
//           context: context,
//           builder: (ctx) => AlertDialog(
//                 title: Text('An error occured!'),
//                 content: Text('Something went wrong'),
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
//     return _isLoading
//         ? Center(
//             child: CircularProgressIndicator(),
//           )
//         : AlertDialog(
//             title: Text('Add Student'),
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
//                   // Row(
//                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     Text("Is Admin ?"),
//                   //     Checkbox(
//                   //         value: _isAdmin,
//                   //         onChanged: (checked) {
//                   //           setState(() {
//                   //             _isAdmin = checked;
//                   //           });
//                   //         })
//                   //   ],
//                   // )
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


