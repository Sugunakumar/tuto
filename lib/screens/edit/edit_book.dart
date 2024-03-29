import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';

import '../../data/constants.dart';

class EditBookScreen extends StatefulWidget {
  static const routeName = '/edit-book';

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _gradeFocusNode = FocusNode();
  final _subjectFocusNode = FocusNode();
  final _pagesFocusNode = FocusNode();
  final _editorFocusNode = FocusNode();
  final _publisherFocusNode = FocusNode();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  // GlobalKey autoCompletionKey =
  //     new GlobalKey<AutoCompleteTextFieldState<Book>>();

  //List<Book> availableBooks;
  //Book selectedBook;

  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedBook = Book(
    id: null,
    grade: '',
    subject: '',
    title: '',
    description: '',
    pages: 0,
    editor: '',
    publisher: '',
    imageUrl: '',
  );

  var _initValues = {
    'grade': null,
    'subject': null,
    'title': '',
    'description': '',
    'pages': '',
    'editor': '',
    'publisher': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  String titleAction = "Add Book";

  @override
  void didChangeDependencies() async {
    final bookData = Provider.of<Books>(context, listen: false);
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedBook = bookData.findBookById(productId);
        _initValues = {
          'grade': _editedBook.grade,
          'subject': _editedBook.subject,
          'title': _editedBook.title,
          'description': _editedBook.description,
          'pages': _editedBook.pages.toString(),
          'editor': _editedBook.editor,
          'publisher': _editedBook.publisher,
          'imageUrl': _editedBook.imageUrl,
        };
        _imageUrlController.text = _editedBook.imageUrl;
        titleAction = "Edit Book";
      }

      //print("availableBooks.length : " + availableBooks.length.toString());
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);

    _gradeFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    _subjectFocusNode.dispose();
    _pagesFocusNode.dispose();
    _editorFocusNode.dispose();
    _publisherFocusNode.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
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
    if (_editedBook.id != null) {
      await Provider.of<Books>(context, listen: false)
          .updateBook(_editedBook.id, _editedBook);
    } else {
      try {
        await Provider.of<Books>(context, listen: false).addBook(_editedBook);
      } catch (e) {
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

  String gradeValue;
  String subjectValue;

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
                          child: DropdownButtonFormField<String>(
                            //value:  gradeValue,
                            value: _initValues['grade'] ?? gradeValue,
                            isExpanded: true,
                            items: grades.keys
                                .map((grade) => DropdownMenuItem(
                                      child: Text(
                                          grade.toString().split('.').last),
                                      value: grade.toString().split('.').last,
                                    ))
                                .toList(),
                            hint: Text('Grade'),
                            onChanged: (value) {
                              setState(() {
                                if (gradeValue != value) subjectValue = null;
                                gradeValue = value;
                              });
                            },
                            onSaved: (value) {
                              _editedBook = Book(
                                title: _editedBook.title,
                                grade: value,
                                subject: _editedBook.subject,
                                description: _editedBook.description,
                                pages: _editedBook.pages,
                                editor: _editedBook.editor,
                                publisher: _editedBook.publisher,
                                imageUrl: _editedBook.imageUrl,
                                id: _editedBook.id,
                                //isFavorite: _editedBook.isFavorite
                              );
                            },
                          ),
                          // UQM
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField(
                            value: _initValues['subject'] ?? subjectValue,
                            items: gradeValue == null
                                ? null
                                : grades[getGradeByString(gradeValue)]
                                    .map((subject) => DropdownMenuItem(
                                          child: Text(subject),
                                          value: subject,
                                        ))
                                    .toList(),
                            hint: Text('Subject'),
                            onChanged: (value) {
                              setState(() {
                                subjectValue = value;
                              });
                            },
                            onSaved: (value) {
                              _editedBook = Book(
                                title: _editedBook.title,
                                grade: _editedBook.grade,
                                subject: value,
                                description: _editedBook.description,
                                pages: _editedBook.pages,
                                editor: _editedBook.editor,
                                publisher: _editedBook.publisher,
                                imageUrl: _editedBook.imageUrl,
                                id: _editedBook.id,
                                //isFavorite: _editedBook.isFavorite
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            initialValue: _initValues['pages'],
                            decoration: InputDecoration(labelText: 'Pages'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _pagesFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_editorFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter no. of pages.';
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
                              _editedBook = Book(
                                title: _editedBook.title,
                                grade: _editedBook.grade,
                                subject: _editedBook.subject,
                                description: _editedBook.description,
                                pages: int.parse(value),
                                editor: _editedBook.editor,
                                publisher: _editedBook.publisher,
                                imageUrl: _editedBook.imageUrl,
                                id: _editedBook.id,
                                //isFavorite: _editedBook.isFavorite,
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: _initValues['editor'],
                            decoration: InputDecoration(
                                labelText: 'Editor',
                                hintText: 'Editor/Author of the book'),
                            textInputAction: TextInputAction.next,
                            focusNode: _editorFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_publisherFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the editor of the book.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedBook = Book(
                                title: _editedBook.title,
                                grade: _editedBook.grade,
                                subject: _editedBook.subject,
                                description: _editedBook.description,
                                pages: _editedBook.pages,
                                editor: value,
                                publisher: _editedBook.publisher,
                                imageUrl: _editedBook.imageUrl,
                                id: _editedBook.id,
                                //isFavorite: _editedBook.isFavorite,
                              );
                            },
                          ),
                          // UQM
                        ),
                      ],
                    ),

                    TextFormField(
                      initialValue: _initValues['publisher'],
                      decoration: InputDecoration(
                        labelText: 'Publisher',
                        hintText: 'Plublisher of the Book',
                      ),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _publisherFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_titleFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter publisher';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          title: _editedBook.title,
                          grade: _editedBook.grade,
                          subject: _editedBook.subject,
                          description: _editedBook.description,
                          pages: _editedBook.pages,
                          editor: _editedBook.editor,
                          publisher: value,
                          imageUrl: _editedBook.imageUrl,
                          id: _editedBook.id,
                          //isFavorite: _editedBook.isFavorite,
                        );
                      },
                    ),

                    // new Column(children: [
                    //   new Container(
                    //     child: new AutoCompleteTextField<Book>(
                    //       decoration: new InputDecoration(
                    //           hintText: "Search Book",
                    //           suffixIcon: new Icon(Icons.search)),
                    //       itemSubmitted: (item) {
                    //         setState(() => selectedBook = item);
                    //         _editedBook = Book(
                    //           title: _editedBook.title,
                    //           grade: _editedBook.grade,
                    //           subject: _editedBook.subject,
                    //           description: _editedBook.description,
                    //           pages: _editedBook.pages,
                    //           editor: _editedBook.editor,
                    //           publisher: _editedBook.publisher,
                    //           imageUrl: _editedBook.imageUrl,
                    //           id: selectedBook.id,
                    //         );
                    //       },
                    //       key: autoCompletionKey,
                    //       suggestions: availableBooks,
                    //       itemBuilder: (context, suggestion) => new Padding(
                    //           child: new ListTile(
                    //             leading: (suggestion.imageUrl ?? "").isEmpty
                    //                 ? CircleAvatar(
                    //                     backgroundImage:
                    //                         NetworkImage(suggestion.imageUrl),
                    //                   )
                    //                 : CircleAvatar(
                    //                     child: Text(suggestion.title.image),
                    //                   ),
                    //             title: new Text(suggestion.title),
                    //             //trailing: new Text("Stars: ${suggestion.stars}")),
                    //           ),
                    //           padding: EdgeInsets.all(8.0)),
                    //       itemSorter: (a, b) => 0,
                    //       itemFilter: (suggestion, input) => suggestion.title
                    //           .toLowerCase()
                    //           .startsWith(input.toLowerCase()),
                    //     ),
                    //   ),
                    //   new Padding(
                    //       padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                    //       child: new Card(
                    //           child: selectedBook != null
                    //               ? new Column(children: [
                    //                   new ListTile(
                    //                     leading: (selectedBook.imageUrl ?? "")
                    //                             .isEmpty
                    //                         ? CircleAvatar(
                    //                             child: Text(
                    //                                 selectedBook.title.image),
                    //                           )
                    //                         : CircleAvatar(
                    //                             backgroundImage: NetworkImage(
                    //                                 selectedBook.imageUrl),
                    //                           ),
                    //                     title: new Text(selectedBook.title),
                    //                     //trailing: new Text("Stars: ${selected.stars}")),
                    //                   ),
                    //                 ])
                    //               : new Icon(Icons.cancel))),
                    // ]),

                    // Title
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      focusNode: _titleFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          title: value,
                          grade: _editedBook.grade,
                          subject: _editedBook.subject,
                          description: _editedBook.description,
                          pages: _editedBook.pages,
                          editor: _editedBook.editor,
                          publisher: _editedBook.publisher,
                          imageUrl: _editedBook.imageUrl,
                          id: _editedBook.id,
                          //isFavorite: _editedBook.isFavorite,
                        );
                      },
                    ),
                    // Price

                    // HSN

                    // Description
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }
                        // if (value.length < 10) {
                        //   return 'Should be at least 10 characters long.';
                        // }
                        return null;
                      },
                      onSaved: (value) {
                        _editedBook = Book(
                          title: _editedBook.title,
                          grade: _editedBook.grade,
                          subject: _editedBook.subject,
                          description: value,
                          pages: _editedBook.pages,
                          editor: _editedBook.editor,
                          publisher: _editedBook.publisher,
                          imageUrl: _editedBook.imageUrl,
                          id: _editedBook.id,
                          //isFavorite: _editedBook.isFavorite,
                        );
                      },
                    ),
                    // Image
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedBook = Book(
                                title: _editedBook.title,
                                grade: _editedBook.grade,
                                subject: _editedBook.subject,
                                description: _editedBook.description,
                                pages: _editedBook.pages,
                                editor: _editedBook.editor,
                                publisher: _editedBook.publisher,
                                imageUrl: value,
                                id: _editedBook.id,
                                //isFavorite: _editedBook.isFavorite,
                              );
                            },
                          ),
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
