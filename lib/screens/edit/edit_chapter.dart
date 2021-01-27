import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chapter.dart';
import '../../providers/chapters.dart';

class EditChapterScreen extends StatefulWidget {
  static const routeName = '/edit-chapter';

  @override
  _EditChapterScreenState createState() => _EditChapterScreenState();
}

class _EditChapterScreenState extends State<EditChapterScreen> {
  final _indexFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _editedChapter = Chapter(
    id: null,
    index: 0,
    title: '',
  );

  var _initValues = {
    'index': '',
    'title': '',
  };
  var _isInit = true;
  var _isLoading = false;
  String titleAction = "Edit Chapter";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final chapterId = ModalRoute.of(context).settings.arguments as String;
      if (chapterId != null) {
        _editedChapter = Provider.of<Chapters>(context, listen: false)
            .findChapterById(chapterId);
        _initValues = {
          'index': _editedChapter.index.toString(),
          'title': _editedChapter.title,
        };
      } else
        titleAction = "Add Chapter";
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _indexFocusNode.dispose();
    _titleFocusNode.dispose();
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
    if (_editedChapter.id != null) {
      await Provider.of<Chapters>(context, listen: false)
          .updateChapter(_editedChapter.id, _editedChapter);
    } else {
      try {
        await Provider.of<Chapters>(context, listen: false)
            .addChapter(_editedChapter);
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            initialValue: _initValues['index'],
                            decoration: InputDecoration(labelText: 'Index'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _indexFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_titleFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter index';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a number greater than zero.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedChapter = Chapter(
                                index: int.parse(value),
                                title: _editedChapter.title,
                                id: _editedChapter.id,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _initValues['title'],
                            decoration: InputDecoration(
                              labelText: 'Title',
                            ),
                            textInputAction: TextInputAction.next,
                            focusNode: _titleFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the editor of the book.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedChapter = Chapter(
                                index: _editedChapter.index,
                                title: value,
                                id: _editedChapter.id,
                              );
                            },
                          ),
                          // UQM
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
