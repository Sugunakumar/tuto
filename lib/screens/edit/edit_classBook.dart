import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:tuto/common/utils.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/classBook.dart';
import 'package:tuto/new_providers/school.dart';

import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/screens/profile/class_profile.dart';

import 'package:tuto/screens/profile/school_profile.dart';

import '../../data/constants.dart';

class EditClassBookScreen extends StatefulWidget {
  static const routeName = '/add-classBook';

  @override
  _EditClassBookScreenState createState() => _EditClassBookScreenState();
}

class _EditClassBookScreenState extends State<EditClassBookScreen> {
  final _bookFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  final _key = new GlobalKey<AutoCompleteTextFieldState<Book>>();

  var _editedClassBook = ClassBook(
    id: null,
    joiningDate: null,
  );

  School _school;
  Class _class;
  var _isInit = true;
  var _isLoading = false;
  String titleAction = "Add Book";
  Books _booksData;
  Book selected;

  //static String _displayStringForOption(Member member) => member.username;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _booksData = Provider.of<Books>(context, listen: false);
      _school = Provider.of<Schools>(context, listen: false)
          .findById(SchoolProfile.schoolId);
      print('_school.classes.length.toString : ' +
          _school.classes.length.toString());

      _class = _school.findClassById(ClassProfile.classId);

      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void dispose() {
    _bookFocusNode.dispose();
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

    _class.addClassBook(_editedClassBook, _school.id);

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
                    new Column(children: [
                      new Container(
                        child: new AutoCompleteTextField<Book>(
                          decoration: new InputDecoration(
                              hintText: "Search Book",
                              suffixIcon: new Icon(Icons.search)),
                          itemSubmitted: (item) {
                            setState(() => selected = item);
                            //selected = item;
                            _editedClassBook = ClassBook(
                                id: item.id, joiningDate: DateTime.now());
                          },
                          key: _key,
                          suggestions: _booksData.books,
                          itemBuilder: (context, suggestion) {
                            return new Padding(
                                child: new ListTile(
                                  leading: suggestion.imageUrl != null ||
                                          suggestion.imageUrl == ""
                                      ? CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(suggestion.imageUrl),
                                        )
                                      : CircleAvatar(
                                          child: Text(suggestion.title[0]
                                              .toUpperCase()),
                                        ),
                                  title: new Text(suggestion.title),
                                  //trailing: new Text("Stars: ${suggestion.stars}")),
                                ),
                                padding: EdgeInsets.all(8.0));
                          },
                          itemSorter: (a, b) => 0,
                          itemFilter: (suggestion, input) => suggestion.title
                              .toLowerCase()
                              .contains(input.toLowerCase()),
                        ),
                      ),
                      new Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                          child: new Card(
                              child: selected != null
                                  ? new Column(children: [
                                      new ListTile(
                                        leading: selected.imageUrl != null ||
                                                selected.imageUrl == ""
                                            ? CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    selected.imageUrl),
                                              )
                                            : CircleAvatar(
                                                child: Text(selected.title[0]
                                                    .toUpperCase()),
                                              ),
                                        title: new Text(selected.title),
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
