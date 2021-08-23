import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/school.dart';

import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/widgets/picker/box_image.dart';

class EditSchoolScreen extends StatefulWidget {
  static const routeName = '/edit-school';

  @override
  _EditSchoolScreenState createState() => _EditSchoolScreenState();
}

class _EditSchoolScreenState extends State<EditSchoolScreen> {
  final _nameFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _boardFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _imageURLFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _edited = School(
    id: null,
    name: '',
    address: '',
    board: '',
    email: '',
    phone: '',
    imageURL: '',
  );

  var _initValues = {
    'name': '',
    'address': '',
    'board': '',
    'email': '',
    'phone': '',
    'imageURL': '',
  };

  var _isInit = true;
  var _isLoading = false;
  String titleAction = "Add School";

  File _imageFile;

  void _pickedImage(File image) {
    _imageFile = image;
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final schoolId = ModalRoute.of(context).settings.arguments as String;
      if (schoolId != null) {
        _edited =
            Provider.of<Schools>(context, listen: false).findById(schoolId);
        _initValues = {
          'name': _edited.name,
          'address': _edited.address,
          'board': _edited.board,
          'email': _edited.email,
          'phone': _edited.phone,
          'imageURL': _edited.imageURL,
        };
        titleAction = "Edit School";
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _addressFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _boardFocusNode.dispose();
    _imageURLFocusNode.dispose();
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
    if (_edited.id != null) {
      await Provider.of<Schools>(context, listen: false)
          .update(_edited.id, _edited);
    } else {
      try {
        await Provider.of<Schools>(context, listen: false)
            .add(_edited, _imageFile);
      } catch (e) {
        print('exception: ' + e.toString());
        await showDialog<Null>(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured!'),
                  content: Text('Something went wrong'),
                  actions: [
                    TextButton(
                      child: Text('Okay'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
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
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      focusNode: _nameFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_addressFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edited = School(
                          name: value,
                          address: _edited.address,
                          board: _edited.board,
                          email: _edited.email,
                          phone: _edited.phone,
                          imageURL: _edited.imageURL,
                          id: _edited.id,
                        );
                      },
                    ),
                    // Address
                    TextFormField(
                      initialValue: _initValues['address'],
                      decoration: InputDecoration(labelText: 'Address'),
                      maxLines: 3,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _addressFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_emailFocusNode);
                      },
                      validator: (value) {
                        if (value.trim().isEmpty)
                          return 'Please enter the address';
                        return null;
                      },
                      onSaved: (value) {
                        _edited = School(
                          name: _edited.name,
                          address: value,
                          email: _edited.email,
                          phone: _edited.phone,
                          board: _edited.board,
                          imageURL: _edited.imageURL,
                          id: _edited.id,
                        );
                      },
                    ),
                    // email
                    TextFormField(
                      initialValue: _initValues['email'],
                      decoration: InputDecoration(labelText: 'Email'),
                      //maxLines: 3,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phoneFocusNode);
                      },
                      validator: (value) {
                        if (value.trim().isEmpty || !value.contains('@'))
                          return 'Please enter a valid email address.';
                        return null;
                      },
                      onSaved: (value) {
                        _edited = School(
                          name: _edited.name,
                          address: _edited.address,
                          email: value,
                          phone: _edited.phone,
                          board: _edited.board,
                          imageURL: _edited.imageURL,
                          id: _edited.id,
                        );
                      },
                    ),

                    // phone
                    TextFormField(
                      initialValue: _initValues['phone'],
                      decoration: InputDecoration(labelText: 'Phone'),
                      //maxLines: 3,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _phoneFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_boardFocusNode);
                      },
                      validator: (value) {
                        if (value.trim().length < 10) {
                          return 'Please enter a valid phone number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edited = School(
                          name: _edited.name,
                          address: _edited.address,
                          email: _edited.email,
                          phone: value,
                          board: _edited.board,
                          imageURL: _edited.imageURL,
                          id: _edited.id,
                        );
                      },
                    ),
                    // Image
                    BoxImagePicker(_pickedImage),
                    // Board
                    TextFormField(
                      initialValue: _initValues['board'],
                      decoration: InputDecoration(labelText: 'Board'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: _boardFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      validator: (value) {
                        if (value.trim().isEmpty)
                          return 'Please enter the Board';
                        return null;
                      },
                      onSaved: (value) {
                        _edited = School(
                          name: _edited.name,
                          address: _edited.address,
                          email: _edited.email,
                          phone: _edited.phone,
                          board: value,
                          imageURL: _edited.imageURL,
                          id: _edited.id,
                        );
                      },
                    ),

                    // Image
                  ],
                ),
              ),
            ),
    );
  }
}
