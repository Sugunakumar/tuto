import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/classTeacher.dart';
import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/profile/school_profile.dart';

import '../../data/constants.dart';

class EditClassScreen extends StatefulWidget {
  static const routeName = '/add-class';

  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  Future<void> _refreshPage(BuildContext context) async {
    await Provider.of<Auth>(context, listen: false).fetchAndSetMembers();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();

    print("auth.members.length : " + auth.members.length.toString());

    return RefreshIndicator(
      onRefresh: () => _refreshPage(context),
      child: auth.members.isNotEmpty
          ? EditClassForm(auth)
          : FutureBuilder(
              future: _refreshPage(context),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  return Center(child: Text('An Error occured'));
                } else {
                  return EditClassForm(auth);
                }
              },
            ),
    );
  }
}

class EditClassForm extends StatefulWidget {
  final Auth auth;
  EditClassForm(this.auth, {Key key}) : super(key: key);

  @override
  _EditClassFormState createState() => _EditClassFormState();
}

class _EditClassFormState extends State<EditClassForm> {
  final _nameFocusNode = FocusNode();
  final _iconFocusNode = FocusNode();
  final _gradeFocusNode = FocusNode();
  final _classTeacherNode = FocusNode();

  final _form = GlobalKey<FormState>();
  final _key = new GlobalKey<AutoCompleteTextFieldState<SchoolTeacher>>();

  var _editedClass = Class(
    id: null,
    name: '',
    icon: '',
    grade: null,
    academicYear: '',
    classTeacher: null,
  );

  var _initValues = {
    'name': '',
    'icon': '',
    'grade': null,
    'academicYear': DateTime.now().year.toString(),
    'classTeacherEmail': '',
  };

  School _school;
  var _isInit = true;
  var _isLoading = false;
  String titleAction = "Add Class";
  SchoolTeacher selected;

  //static String _displayStringForOption(Member member) => member.username;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final schoolId = SchoolProfile.schoolId;
      _school = Provider.of<Schools>(context, listen: false).findById(schoolId);

      final classId = ModalRoute.of(context).settings.arguments as String;
      if (classId != null) {
        _editedClass = _school.findClassById(classId);
        _initValues = {
          'name': _editedClass.name,
          'icon': _editedClass.icon,
          'grade': _editedClass.grade.toString().split('.').last,
          'academicYear': _editedClass.academicYear,
          'classTeacherEmail': _editedClass.classTeacher.user.email,
        };
        titleAction = "Edit Class";
      }

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _gradeFocusNode.dispose();
    _classTeacherNode.dispose();
    _iconFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedClass.id == null) {
      _school.addClass(_editedClass);
    } else {
      print('update : ' + _editedClass.toString());
      _school.updateClass(_editedClass.id, _editedClass);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  String gradeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAction),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    // Grade
                    DropdownButtonFormField<String>(
                      //value:  gradeValue,
                      value: _initValues['grade'] ?? gradeValue,
                      focusNode: _gradeFocusNode,
                      isExpanded: true,
                      items: grades.keys
                          .map((grade) => DropdownMenuItem(
                                child: Text(grade.toString().split('.').last),
                                value: grade.toString().split('.').last,
                              ))
                          .toList(),
                      hint: Text('Grade'),

                      onChanged: (value) {
                        setState(() {
                          gradeValue = value;
                          FocusScope.of(context).requestFocus(_nameFocusNode);
                        });
                      },
                      onSaved: (value) {
                        _editedClass = Class(
                          name: _editedClass.name,
                          icon: _editedClass.icon,
                          grade: grades.keys.firstWhere((element) =>
                              element.toString().split(".").last == value),
                          id: _editedClass.id,
                          academicYear: _editedClass.academicYear,
                          classTeacher: _editedClass.classTeacher,
                        );
                      },
                    ),

                    SizedBox(width: 10),
                    // name
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      focusNode: _nameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_iconFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedClass = Class(
                          name: value,
                          icon: _editedClass.icon,
                          grade: _editedClass.grade,
                          id: _editedClass.id,
                          academicYear: _editedClass.academicYear,
                          classTeacher: _editedClass.classTeacher,
                        );
                      },
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    TextFormField(
                      initialValue: _initValues['icon'],
                      decoration: InputDecoration(labelText: 'Icon Name'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      focusNode: _iconFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter icon name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedClass = Class(
                          name: _editedClass.name,
                          icon: value,
                          grade: _editedClass.grade,
                          id: _editedClass.id,
                          academicYear: _editedClass.academicYear,
                          classTeacher: _editedClass.classTeacher,
                        );
                      },
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    new Column(children: [
                      new Container(
                        child: new AutoCompleteTextField<SchoolTeacher>(
                          decoration: new InputDecoration(
                              hintText: "Search Class Teacher",
                              suffixIcon: new Icon(Icons.search)),
                          itemSubmitted: (item) {
                            setState(() => selected = item);
                            //selected = item;
                            _editedClass = Class(
                              name: _editedClass.name,
                              icon: _editedClass.icon,
                              grade: _editedClass.grade,
                              academicYear: _editedClass.academicYear,
                              id: _editedClass.id,
                              classTeacher: item,
                              // ClassTeacher(
                              //     joiningDate: DateTime.now(),
                              //     schoolTeacher: item
                            );
                          },
                          key: _key,
                          suggestions: _school.teachers,
                          itemBuilder: (context, suggestion) => new Padding(
                              child: new ListTile(
                                leading: suggestion.user.imageURL != null ||
                                        suggestion.user.imageURL == ""
                                    ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            suggestion.user.imageURL),
                                      )
                                    : CircleAvatar(
                                        child: Text(suggestion.user.username[0]
                                            .toUpperCase()),
                                      ),
                                title: new Text(suggestion.user.username),
                                //trailing: new Text("Stars: ${suggestion.stars}")),
                              ),
                              padding: EdgeInsets.all(8.0)),
                          itemSorter: (a, b) => 0,
                          itemFilter: (suggestion, input) => suggestion
                              .user.username
                              .toLowerCase()
                              .startsWith(input.toLowerCase()),
                        ),
                      ),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                          child: new Card(
                              child: selected != null
                                  ? new Column(children: [
                                      new ListTile(
                                        leading: selected.user.imageURL !=
                                                    null ||
                                                selected.user.imageURL == ""
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    selected.user.imageURL),
                                              )
                                            : CircleAvatar(
                                                child: Text(selected
                                                    .user.username[0]
                                                    .toUpperCase()),
                                              ),
                                        title: new Text(selected.user.username),
                                        //trailing: new Text("Stars: ${selected.stars}")),
                                      ),
                                    ])
                                  : new Icon(Icons.cancel))),
                    ]),
                    // added != null
                    //     ? Padding(
                    //         padding: const EdgeInsets.all(16.0),
                    //         child: Text(added.name),
                    //       )
                    //     : Container(),

                    ElevatedButton(
                      child: Text('Add Class'),
                      onPressed: () {
                        _saveForm();
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
