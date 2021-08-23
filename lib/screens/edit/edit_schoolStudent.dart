import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';

import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolStudent.dart';

import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/screens/profile/school_profile.dart';

import '../../data/constants.dart';

class EditSchoolStudentScreen extends StatefulWidget {
  static const routeName = '/add-schoolStudent';

  @override
  _EditSchoolStudentScreenState createState() =>
      _EditSchoolStudentScreenState();
}

class _EditSchoolStudentScreenState extends State<EditSchoolStudentScreen> {
  final _nameFocusNode = FocusNode();
  final _fatherNameFocusNode = FocusNode();
  final _motherNameFocusNode = FocusNode();
  final _previousSchoolFocusNode = FocusNode();
  final _previousSchoolGradeFocusNode = FocusNode();
  final _studenNumberFocusNode = FocusNode();
  final _dateOfBirthFocusNode = FocusNode();
  final _joiningDateFocusNode = FocusNode();
  final _emergencyContactFocusNode = FocusNode();
  final _totalFeeFocusNode = FocusNode();
  final _paidFeeFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  final _emailForm = GlobalKey<FormState>();

  final TextEditingController _searchQuery = new TextEditingController();

  

  var _editedStudent = SchoolStudent(
      fatherName: '',
      motherName: '',
      previousSchool: '',
      previousSchoolGrade: null,
      studenNumber: '',
      dateOfBirth: null,
      joiningDate: null,
      emergencyContact: null,
      totalFee: null,
      paidFee: null,
      user: null);

  var _initValues = {
    'email': '',
    'fatherName': '',
    'motherName': '',
    'previousSchool': null,
    'previousSchoolGrade': '',
    'studenNumber': '',
    'dateOfBirth': '',
    'joiningDate': '',
    'emergencyContact': 0,
    'totalFee': 0,
    'paidFee': 0,
  };

  School _school;
  var _isInit = true;
  var _isLoading = false;
  var _isValidation = false;
  var _validationFailed = false;
  String titleAction = "Student Admission";
  Member _selectedMember;

  DateTime _seletedDate;

  //static String _displayStringForOption(Member member) => member.username;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final schoolId = SchoolProfile.schoolId;
      _school = Provider.of<Schools>(context, listen: false).findById(schoolId);

      final studentId = ModalRoute.of(context).settings.arguments as String;
      if (studentId != null) {
        _editedStudent = _school.findStudentById(studentId);
        _initValues = {
          'email': _editedStudent.user.email,
          'fatherName': _editedStudent.fatherName,
          'motherName': _editedStudent.motherName,
          'previousSchool': _editedStudent.previousSchool,
          'previousSchoolGrade':
              _editedStudent.previousSchoolGrade.toString().split('.').last,
          'studenNumber': _editedStudent.studenNumber,
          'dateOfBirth': _editedStudent.dateOfBirth,
          'joiningDate': _editedStudent.joiningDate,
          'emergencyContact': _editedStudent.emergencyContact,
          'totalFee': _editedStudent.totalFee,
          'paidFee': _editedStudent.paidFee,
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
    _fatherNameFocusNode.dispose();
    _motherNameFocusNode.dispose();
    _previousSchoolFocusNode.dispose();
    _previousSchoolGradeFocusNode.dispose();
    _studenNumberFocusNode.dispose();
    _dateOfBirthFocusNode.dispose();
    _joiningDateFocusNode.dispose();
    _emergencyContactFocusNode.dispose();
    _totalFeeFocusNode.dispose();
    _paidFeeFocusNode.dispose();
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
    print('_editedStudent ' + _editedStudent.toString());

    if (_editedStudent.user == null) {
      print('add  : ' + _editedStudent.toString());
      _editedStudent = SchoolStudent(
          fatherName: _editedStudent.fatherName,
          motherName: _editedStudent.motherName,
          previousSchool: _editedStudent.previousSchool,
          previousSchoolGrade: _editedStudent.previousSchoolGrade,
          studenNumber: _editedStudent.studenNumber,
          dateOfBirth: _seletedDate,
          joiningDate: _editedStudent.joiningDate,
          user: _selectedMember);
      _school.addSchoolStudent(_editedStudent);
    } else {
      print('update : ' + _editedStudent.toString());
      _school.updateStudent(_editedStudent.user.id, _editedStudent);
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Future<void> _validateEmail(String email) async {
    final isValid = _emailForm.currentState.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isValidation = true;
    });
    final Auth auth = Provider.of<Auth>(context, listen: false);
    Member mem = await auth.fetchUserByEmail(email.trim());

    setState(() {
      _isValidation = false;
      _selectedMember = mem;
      if (mem == null) _validationFailed = true;
    });
    _emailForm.currentState.validate();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year - 10),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        _seletedDate = value;
        print("_seletedDate : " + DateFormat.yMd().format(_seletedDate));
      });
    });
  }

  String gradeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAction),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.save),
        //     onPressed: _saveForm,
        //   ),
        // ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: _selectedMember == null
                  ? Form(
                      key: _emailForm,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              initialValue: _initValues['name'],
                              controller: _searchQuery,
                              decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: 'Enter the email and hit Validate'),
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.text,
                              focusNode: _nameFocusNode,
                              onFieldSubmitted: (value) {
                                _validateEmail(value);

                                FocusScope.of(context).requestFocus(
                                    _previousSchoolGradeFocusNode);
                              },
                              validator: (value) {
                                if (value.isEmpty ||
                                    !value.contains('@') ||
                                    !value.contains('.')) {
                                  return 'Please enter a valid email address.';
                                }
                                print('_validationFailed : ' +
                                    _validationFailed.toString());
                                if (_validationFailed)
                                  return 'The user is not registered. \nPlease request the user to sign up.';
                                return null;
                              },
                            ),
                          ),
                          _isValidation
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _validationFailed = false;
                                    });
                                    print('pressed search query button : ' +
                                        _searchQuery.text.toString());
                                    _validateEmail(_searchQuery.text);
                                  },
                                  icon: Icon(Icons.refresh),
                                  label: Text("Validate"),
                                )
                        ],
                      ),
                    )
                  : Form(
                      key: _form,
                      child: ListView(children: <Widget>[
                        new Card(
                          child: new ListTile(
                            leading: _selectedMember.imageURL != null ||
                                    _selectedMember.imageURL == ""
                                ? CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(_selectedMember.imageURL),
                                  )
                                : CircleAvatar(
                                    child: Text(
                                        _selectedMember.username[0].toUpperCase()),
                                  ),
                            title: new Text(_selectedMember.username),
                            subtitle: new Text(_selectedMember.email),
                            onTap: () {
                              setState(() {
                                _selectedMember = null;
                              });
                              print('tapped on schoolstudent');
                            }, //trailing: new Text("Stars: ${selected.stars}")),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),

                        TextFormField(
                          initialValue: _initValues['fatherName'],
                          decoration: InputDecoration(labelText: 'Father Name'),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _fatherNameFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_motherNameFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedStudent = SchoolStudent(
                                fatherName: value,
                                motherName: _editedStudent.motherName,
                                previousSchool: _editedStudent.previousSchool,
                                previousSchoolGrade:
                                    _editedStudent.previousSchoolGrade,
                                studenNumber: _editedStudent.studenNumber,
                                dateOfBirth: _editedStudent.dateOfBirth,
                                joiningDate: _editedStudent.joiningDate,
                                user: _editedStudent.user);
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: _initValues['motherName'],
                          decoration: InputDecoration(labelText: 'Mother Name'),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _motherNameFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_previousSchoolFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the Name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedStudent = SchoolStudent(
                                fatherName: _editedStudent.fatherName,
                                motherName: value,
                                previousSchool: _editedStudent.previousSchool,
                                previousSchoolGrade:
                                    _editedStudent.previousSchoolGrade,
                                studenNumber: _editedStudent.studenNumber,
                                dateOfBirth: _editedStudent.dateOfBirth,
                                joiningDate: _editedStudent.joiningDate,
                                user: _editedStudent.user);
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: _initValues['previousSchool'],
                          decoration: InputDecoration(
                              labelText: 'Previous School Name'),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _previousSchoolFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .requestFocus(_previousSchoolGradeFocusNode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter the previous school name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _editedStudent = SchoolStudent(
                                fatherName: _editedStudent.fatherName,
                                motherName: _editedStudent.motherName,
                                previousSchool: value,
                                previousSchoolGrade:
                                    _editedStudent.previousSchoolGrade,
                                studenNumber: _editedStudent.studenNumber,
                                dateOfBirth: _editedStudent.dateOfBirth,
                                joiningDate: _editedStudent.joiningDate,
                                user: _editedStudent.user);
                          },
                        ),
                        SizedBox(height: 10),

                        // Grade
                        DropdownButtonFormField<String>(
                          //value:  gradeValue,

                          value: _initValues['grade'] ?? gradeValue,
                          focusNode: _previousSchoolGradeFocusNode,
                          isExpanded: true,
                          items: grades.keys
                              .map((grade) => DropdownMenuItem(
                                    child:
                                        Text(grade.toString().split('.').last),
                                    value: grade.toString().split('.').last,
                                  ))
                              .toList(),
                          hint: Text('Select Previous School Grade'),

                          onChanged: (value) {
                            setState(() {
                              gradeValue = value;
                              FocusScope.of(context)
                                  .requestFocus(_dateOfBirthFocusNode);
                            });
                          },
                          onSaved: (value) {
                            _editedStudent = SchoolStudent(
                                fatherName: _editedStudent.fatherName,
                                motherName: _editedStudent.motherName,
                                previousSchool: _editedStudent.previousSchool,
                                previousSchoolGrade: getGradeByString(value),
                                studenNumber: _editedStudent.studenNumber,
                                dateOfBirth: _editedStudent.dateOfBirth,
                                joiningDate: _editedStudent.joiningDate,
                                user: _editedStudent.user);
                          },
                        ),

                        Container(
                          height: 70,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(_seletedDate == null
                                    ? 'Date of Birth : No Date Choosen'
                                    : 'Date of Birth : ${DateFormat.yMd().format(_seletedDate)}'),
                              ),
                              TextButton(
                                  onPressed: _presentDatePicker,
                                  child: Text('Choose Date'))
                            ],
                          ),
                        ),

                        ElevatedButton(
                          child: Text('Add Class'),
                          onPressed: () {
                            _saveForm();
                          },
                        )
                      ]),
                    ),
            ),
    );
  }
}
