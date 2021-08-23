import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/profile/school_profile.dart';
import '../../new_providers/schoolTeacher.dart';

class EditSchoolTeacherScreen extends StatefulWidget {
  static const routeName = '/add-schoolTeacher';

  @override
  _EditSchoolTeacherScreenState createState() =>
      _EditSchoolTeacherScreenState();
}

class _EditSchoolTeacherScreenState extends State<EditSchoolTeacherScreen> {
  final _emailFocusNode = FocusNode();
  final _qualificationFocusNode = FocusNode();
  final _experienceFocusNode = FocusNode();
  final _salaryFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  final _emailForm = GlobalKey<FormState>();

  final TextEditingController _searchQuery = new TextEditingController();

  var _edited = SchoolTeacher(
    qualification: '',
    experience: 0,
    user: null,
    salary: 0,
  );

  var _initValues = {
    'email': '',
    'qualification': 'B.Ed.,',
    'experience': 1,
    'salary': 10000,
  };

  School _school;

  var _isInit = true;
  var _isLoading = false;
  var _isValidation = false;
  var _validationFailed = false;

  Member _selectedMember;
  String titleAction = "Add Teacher";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final schoolId = SchoolProfile.schoolId;

      _school = Provider.of<Schools>(context, listen: false).findById(schoolId);

      final teacherId = ModalRoute.of(context).settings.arguments as String;
      if (teacherId != null) {
        _edited = _school.findTeacherById(teacherId);

        _initValues = {
          'email': _edited.user.email,
          'qualification': _edited.qualification,
          'experience': _edited.experience,
          'salary': _edited.salary,
        };
        titleAction = "Edit School Teacher";
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _qualificationFocusNode.dispose();
    _experienceFocusNode.dispose();
    _salaryFocusNode.dispose();
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

    print('_edited : ' + _edited.toString());
    print('_school  :' + _school.name);

    // add
    if (_edited.user == null) {
      _edited = SchoolTeacher(
        qualification: _edited.qualification,
        experience: _edited.experience,
        user: _selectedMember,
        salary: _edited.salary,
      );

      _school.addSchoolTeacher(_edited);
    } else // update
    {
      print("update not impleted");
    }

    setState(() {
      _isLoading = false;
      //teachersEmailList.clear();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAction),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.save),
        //     onPressed: () {
        //       _saveForm();
        //     },
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
                              focusNode: _emailFocusNode,
                              onFieldSubmitted: (value) {
                                _validateEmail(value);

                                FocusScope.of(context)
                                    .requestFocus(_qualificationFocusNode);
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
                      child: ListView(
                        children: <Widget>[
                          new Card(
                            child: new ListTile(
                              leading: _selectedMember.imageURL != null ||
                                      _selectedMember.imageURL == ""
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _selectedMember.imageURL),
                                    )
                                  : CircleAvatar(
                                      child: Text(_selectedMember.username[0]
                                          .toUpperCase()),
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
                            initialValue: _initValues['qualification'],
                            decoration:
                                InputDecoration(labelText: 'Qualification'),
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            focusNode: _qualificationFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_experienceFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the Qualification';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _edited = SchoolTeacher(
                                qualification: value,
                                experience: _edited.experience,
                                user: _edited.user,
                                salary: _edited.salary,
                              );
                            },
                          ),
                          // Address
                          TextFormField(
                            initialValue: _initValues['experience'].toString(),
                            decoration: InputDecoration(
                                labelText: 'Experience',
                                hintText: 'Total Experiance in years'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _experienceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_salaryFocusNode);
                            },
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'Please enter the experience in number of years';
                              return null;
                            },
                            onSaved: (value) {
                              _edited = SchoolTeacher(
                                qualification: _edited.qualification,
                                experience: int.parse(value),
                                user: _edited.user,
                                salary: _edited.salary,
                              );
                            },
                          ),

                          TextFormField(
                            initialValue: _initValues['salary'].toString(),
                            decoration: InputDecoration(labelText: 'Salary'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: _salaryFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.trim().isEmpty)
                                return 'Please enter the salary per month';
                              return null;
                            },
                            onSaved: (value) {
                              _edited = SchoolTeacher(
                                qualification: _edited.qualification,
                                experience: _edited.experience,
                                user: _edited.user,
                                salary: int.parse(value),
                              );
                            },
                          ),
                          ElevatedButton(
                            child: Text('Add Teacher'),
                            onPressed: () {
                              _saveForm();
                            },
                          )
                          // ..._getTeachers(),
                          // FlatButton(
                          //   onPressed: () {
                          //     _saveForm();
                          //   },
                          //   child: Text('Add'),
                          //   color: Colors.blueAccent,
                          // ),
                          // Image
                        ],
                      ),
                    ),
            ),
    );
  }
}

// List<Widget> _getTeachers() {
//   List<Widget> friendsTextFields = [];
//   print("friendsList.length : " + teachersEmailList.length.toString());
//   for (int i = 0; i < teachersEmailList.length; i++) {
//     friendsTextFields.add(Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Row(
//         children: [
//           Expanded(child: FriendTextFields(i)),
//           SizedBox(
//             width: 16,
//           ),
//           // we need add button at last friends row
//           _addRemoveButton(i == teachersEmailList.length - 1, i),
//         ],
//       ),
//     ));
//   }
//   return friendsTextFields;
// }

//   Widget _addRemoveButton(bool add, int index) {
//     return InkWell(
//       onTap: () {
//         if (add) {
//           // add new text-fields at the top of all friends textfields
//           teachersEmailList.insert(0, null);
//         } else
//           teachersEmailList.removeAt(index);
//         setState(() {});
//       },
//       child: Container(
//         width: 30,
//         height: 30,
//         decoration: BoxDecoration(
//           color: (add) ? Colors.green : Colors.red,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Icon(
//           (add) ? Icons.add : Icons.remove,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

// class FriendTextFields extends StatefulWidget {
//   final int index;
//   FriendTextFields(this.index);
//   @override
//   _FriendTextFieldsState createState() => _FriendTextFieldsState();
// }

// class _FriendTextFieldsState extends State<FriendTextFields> {
//   TextEditingController _nameController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       _nameController.text =
//           _EditSchoolTeacherScreenState.teachersEmailList[widget.index] ?? '';
//     });

//     return TextFormField(
//         controller: _nameController,
//         onChanged: (v) =>
//             _EditSchoolTeacherScreenState.teachersEmailList[widget.index] = v,
//         decoration: InputDecoration(hintText: 'Email'),
//         validator: (value) {
//           if (value.trim().isEmpty || !value.contains('@')) {
//             return 'Please enter a valid email address.';
//           }
//           return null;
//         },
//         onSaved: (value) {
//           _EditSchoolTeacherScreenState.teachersEmailList.add(value);
//           // _EditTeacherScreenState._editedQuestion = Question(
//           //   mark: _EditQuestionScreenState._editedQuestion.mark,
//           //   type: _EditQuestionScreenState._editedQuestion.type,
//           //   question: _EditQuestionScreenState._editedQuestion.question,
//           //   answer: _EditQuestionScreenState._editedQuestion.answer,
//           //   incorrectAnswers: _EditQuestionScreenState.teachersEmailList,
//           //   id: _EditQuestionScreenState._editedQuestion.id,
//           // );
//         });
//   }
