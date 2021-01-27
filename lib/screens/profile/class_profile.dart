import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/class.dart';
import '../../models/user.dart';

import '../../providers/auth.dart';
import '../../providers/classes.dart';
import '../../providers/students.dart';
import '../../providers/tasks.dart';

import '../../widgets/students_list.dart';

Class loadedClass;
Students studentsData;
Tasks tasksData;
Auth authProvider;
Classes classesData;

class ClassProfile extends StatefulWidget {
  static const routeName = '/class-profile';

  @override
  _ClassProfileState createState() => _ClassProfileState();
}

class _ClassProfileState extends State<ClassProfile>
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
    final classId = ModalRoute.of(context).settings.arguments as String;
    print("classId : " + classId);

    classesData = Provider.of<Classes>(context, listen: false);
    loadedClass = classesData.findById(classId);
    studentsData = Provider.of<Students>(context, listen: false);
    tasksData = Provider.of<Tasks>(context, listen: false);
    authProvider = Provider.of<Auth>(context, listen: false);

    return SafeArea(
      top: false,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(child: Text("Students")),
                Tab(child: Text("Subjects")),
              ],
            ),
            title: Text(loadedClass.name),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              StudentsTab(),
              Center(
                child: Container(
                  child: Text("Menu Page"),
                ),
              ),
              //TabList(),
            ],
          ),
          floatingActionButton: _bottomButtons(),
        ),
      ),
    );
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
            print('students');
            await addTeacherByEmailDialog(context);
            //Navigator.of(context).pushNamed(EditTeacherScreen.routeName),
          },
          child: Icon(
            Icons.add,
          ));
    } else if (_tabController.index == 1) {
      return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () {
          print('subjects');
          //Navigator.of(context).pushNamed(EditClassScreen.routeName),
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
      await studentsData.add(addedUser);
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
            title: Text('Add Student'),
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

class StudentsTab extends StatelessWidget {
  const StudentsTab({Key key}) : super(key: key);

  Future<void> _refresh(BuildContext context) async {
    await studentsData.fetchAndSet(classesData.schoolId, loadedClass.id);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refresh(context),
      child: studentsData.items.isEmpty
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
                  return StudentsList();
                }
              })
          : StudentsList(),
    );
  }
}
