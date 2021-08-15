import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/member.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/profile/school_profile.dart';
import '../../new_providers/schoolTeacher.dart';

class EditSchoolTeacherScreen extends StatefulWidget {
  static const routeName = '/add-teacher';

  @override
  _EditSchoolTeacherScreenState createState() =>
      _EditSchoolTeacherScreenState();
}

class _EditSchoolTeacherScreenState extends State<EditSchoolTeacherScreen> {
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
          ? EditSchoolForm(auth)
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
                  return EditSchoolForm(auth);
                }
              },
            ),
    );
  }
}

class EditSchoolForm extends StatefulWidget {
  final Auth auth;
  EditSchoolForm(this.auth, {Key key}) : super(key: key);

  @override
  _EditSchoolFormState createState() => _EditSchoolFormState();
}

class _EditSchoolFormState extends State<EditSchoolForm> {
  final _emailFocusNode = FocusNode();
  final _qualificationFocusNode = FocusNode();
  final _experienceFocusNode = FocusNode();
  final _salaryFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

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

  //final TextEditingController _typeAheadController = TextEditingController();
  //String _selectedCity;
  //String email = '';
  //var _edited = Teacher(userId: '', name: '', imageURL: '');

  var _isInit = true;
  var _isLoading = false;

  //Member addedUser;
  String titleAction = "Add Teacher";
  var teacherId;

  static String _displayStringForOption(Member member) => member.username;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final schoolId = SchoolProfile.schoolId;
      print('schoolId ' + schoolId);
      _school = Provider.of<Schools>(context, listen: false).findById(schoolId);
      print('_school  :' + _school.name);
      teacherId = ModalRoute.of(context).settings.arguments as String;
      if (teacherId != null) {
        print('teacherId ' + teacherId);
        _edited = _school.findTeacherById(teacherId);
        print('_edited experience :' + _edited.experience.toString());

        _initValues = {
          'email': _edited.user.email,
          'qualification': _edited.qualification,
          'experience': _edited.experience,
          'salary': _edited.salary,
        };
        titleAction = "Edit Teacher";
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
    print('_edited email :' + _edited.user.email);
    print('_school  :' + _school.name);

    // add
    //if (_edited.id == null) {
    _school.addTeacher(_edited);
    // } else // update
    // {
    //   //_school.addTeacher(_edited);
    // }

    setState(() {
      _isLoading = false;
      //teachersEmailList.clear();
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleAction),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
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
                    Text("Email"),
                    teacherId == null
                        ? Autocomplete<Member>(
                            displayStringForOption: _displayStringForOption,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.length < 3 ||
                                  !textEditingValue.text.contains('@')) {
                                return const Iterable<Member>.empty();
                              }
                              return widget.auth.members.where((Member option) {
                                return option.email.toString().contains(
                                    textEditingValue.text.toLowerCase());
                              });
                            },
                            onSelected: (Member selection) {
                              print(
                                  'You just selected ${_displayStringForOption(selection)}');

                              print('onsaved');
                              _edited = SchoolTeacher(
                                qualification: _edited.qualification,
                                experience: _edited.experience,
                                user: selection,
                                salary: _edited.salary,
                              );
                            },
                          )
                        : Text(_initValues['email']),
                    TextFormField(
                      initialValue: _initValues['qualification'],
                      decoration: InputDecoration(labelText: 'Qualification'),
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
                      decoration: InputDecoration(labelText: 'Experience'),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _experienceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_salaryFocusNode);
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
