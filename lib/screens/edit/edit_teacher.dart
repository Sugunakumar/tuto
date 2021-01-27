import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:tuto/providers/auth.dart';
import '../../providers/teachers.dart';

class EditTeacherScreen extends StatefulWidget {
  static const routeName = '/add-teacher';

  @override
  _EditTeacherScreenState createState() => _EditTeacherScreenState();
}

class _EditTeacherScreenState extends State<EditTeacherScreen> {
  static List<String> teachersEmailList = [null];

  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  //final TextEditingController _typeAheadController = TextEditingController();
  //String _selectedCity;
  String email = '';
  //var _edited = Teacher(userId: '', name: '', imageURL: '');

  var _isInit = true;
  var _isLoading = false;
  String titleAction = "Add Teacher";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final teacherId = ModalRoute.of(context).settings.arguments as String;
      if (teacherId != null) {
        print('no ' + teacherId);
        //_edited = Provider.of<Teachers>(context, listen: false).findById(teacherId);
        titleAction = "Edit Teacher";
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
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
    //final authProvider = Provider.of<Auth>(context, listen: false);
    for (var email in teachersEmailList) {
      String username = email.split('@')[0];
      try {
        print('save button clicked');
        // UserCredential userCredential = await Auth.register(email, 'P@ssw0rd');
        // String useruid = userCredential.user.uid;

        // await Provider.of<Teachers>(context, listen: false)
        //    .add(useruid, email, username);
      } catch (e) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occured!'),
            content: Text(email + ' already exists'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
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
                    // TypeAheadFormField(
                    //   textFieldConfiguration: TextFieldConfiguration(
                    //       controller: this._typeAheadController,
                    //       decoration: InputDecoration(labelText: 'City')),
                    //   suggestionsCallback: (pattern) {
                    //     return CitiesService.getSuggestions(pattern);
                    //   },
                    //   itemBuilder: (context, suggestion) {
                    //     return ListTile(
                    //       title: Text(suggestion),
                    //     );
                    //   },
                    //   transitionBuilder: (context, suggestionsBox, controller) {
                    //     return suggestionsBox;
                    //   },
                    //   onSuggestionSelected: (suggestion) {
                    //     this._typeAheadController.text = suggestion;
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please select a city';
                    //     }
                    //   },
                    //   onSaved: (value) => this._selectedCity = value,
                    // ),

                    ..._getTeachers(),
                    FlatButton(
                      onPressed: () {
                        _saveForm();
                      },
                      child: Text('Add'),
                      color: Colors.blueAccent,
                    ),
                    // Image
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _getTeachers() {
    List<Widget> friendsTextFields = [];
    print("friendsList.length : " + teachersEmailList.length.toString());
    for (int i = 0; i < teachersEmailList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: FriendTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == teachersEmailList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          teachersEmailList.insert(0, null);
        } else
          teachersEmailList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);
  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text =
          _EditTeacherScreenState.teachersEmailList[widget.index] ?? '';
    });

    return TextFormField(
        controller: _nameController,
        onChanged: (v) =>
            _EditTeacherScreenState.teachersEmailList[widget.index] = v,
        decoration: InputDecoration(hintText: 'Email'),
        validator: (value) {
          if (value.trim().isEmpty || !value.contains('@')) {
            return 'Please enter a valid email address.';
          }
          return null;
        },
        onSaved: (value) {
          _EditTeacherScreenState.teachersEmailList.add(value);
          // _EditTeacherScreenState._editedQuestion = Question(
          //   mark: _EditQuestionScreenState._editedQuestion.mark,
          //   type: _EditQuestionScreenState._editedQuestion.type,
          //   question: _EditQuestionScreenState._editedQuestion.question,
          //   answer: _EditQuestionScreenState._editedQuestion.answer,
          //   incorrectAnswers: _EditQuestionScreenState.teachersEmailList,
          //   id: _EditQuestionScreenState._editedQuestion.id,
          // );
        });
  }
}
