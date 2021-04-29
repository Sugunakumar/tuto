import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/school.dart';

import '../../data/constants.dart';

class EditClassScreen extends StatefulWidget {
  static const routeName = '/edit-class';

  @override
  _EditClassScreenState createState() => _EditClassScreenState();
}

class _EditClassScreenState extends State<EditClassScreen> {
  final _nameFocusNode = FocusNode();
  final _gradeFocusNode = FocusNode();
  final _classTeacherNode = FocusNode();

  final _form = GlobalKey<FormState>();
  final _key = new GlobalKey<AutoCompleteTextFieldState<Teacher>>();

  Teacher selected;
  List<Teacher> teachers;

  var _editedClass = Class(
    id: null,
    name: '',
    grade: '',
    classTeacher: null,
  );

  var _initValues = {
    'name': '',
    'grade': null,
    'classTeacher': Teacher,
  };
  var _isInit = true;
  var _isLoading = false;
  String titleAction = "Add Class";

  @override
  void didChangeDependencies() async {
    final schoolData = Provider.of<SchoolNotifier>(context, listen: false);
    if (_isInit) {
      final classId = ModalRoute.of(context).settings.arguments as String;
      if (classId != null) {
        _editedClass = schoolData.findClassById(classId);
        _initValues = {
          'name': _editedClass.name,
          'grade': _editedClass.grade,
          'classTeacher': _editedClass.classTeacher,
        };
        selected = _editedClass.classTeacher;
        titleAction = "Edit Class";
      }

      teachers = schoolData.teachers;
      if (teachers.isEmpty) {
        await schoolData.fetchAndSetTeachers();
        setState(() {
          teachers = schoolData.teachers;
        });

        print('fetchAndSetTeachers called in editclass : ' +
            teachers.length.toString());
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _gradeFocusNode.dispose();
    _classTeacherNode.dispose();
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
    if (_editedClass.id != null) {
      print('update : ' + _editedClass.toString());
      await Provider.of<SchoolNotifier>(context, listen: false)
          .updateClass(_editedClass.id, _editedClass);
    } else {
      try {
        print('add : ' + _editedClass.classTeacher.user.username);
        await Provider.of<SchoolNotifier>(context, listen: false)
            .addClass(_editedClass);
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
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  String gradeValue;
  String currentText = "";

  @override
  Widget build(BuildContext context) {
    print("teachers.length : " + teachers.length.toString());
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
                          .map((grades) => DropdownMenuItem(
                                child: Text(grades),
                                value: grades,
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
                          grade: value,
                          id: _editedClass.id,
                          classTeacher: _editedClass.classTeacher,
                        );
                      },
                    ),

                    SizedBox(width: 10),
                    // name
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      focusNode: _nameFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
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
                          grade: _editedClass.grade,
                          id: _editedClass.id,
                          classTeacher: _editedClass.classTeacher,
                        );
                      },
                    ),

                    SizedBox(
                      height: 10.0,
                    ),

                    new Column(children: [
                      new Container(
                        child: new AutoCompleteTextField<Teacher>(
                          decoration: new InputDecoration(
                              hintText: "Search Class Teacher",
                              suffixIcon: new Icon(Icons.search)),
                          itemSubmitted: (item) {
                            setState(() => selected = item);
                            //selected = item;
                            _editedClass = Class(
                              name: _editedClass.name,
                              grade: _editedClass.grade,
                              id: _editedClass.id,
                              classTeacher: selected,
                            );
                          },
                          key: _key,
                          suggestions: teachers,
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

                    RaisedButton(
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
