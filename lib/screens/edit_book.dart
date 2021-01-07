import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/books.dart';
import '../data/constants.dart';

class EditBookScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _priceFocusNode = FocusNode();
  final _cgstFocusNode = FocusNode();
  final _sgstFocusNode = FocusNode();
  final _igstFocusNode = FocusNode();
  final _hsnFocusNode = FocusNode();
  final _uqmFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Book(
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
  final _cgstController = TextEditingController(text: '2.5');
  final _sgstController = TextEditingController(text: '2.5');
  final _igstController = TextEditingController(text: '1');

  var _isInit = true;
  var _isLoading = false;
  double _totalGst;

  String titleAction = "Edit Book";

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _cgstFocusNode.addListener(_updateTotalGST);
    _sgstFocusNode.addListener(_updateTotalGST);
    _igstFocusNode.addListener(_updateTotalGST);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Books>(context, listen: false).findBookById(productId);
        _initValues = {
          'grade': _editedProduct.grade,
          'subject': _editedProduct.subject,
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'pages': _editedProduct.pages.toString(),
          'editor': _editedProduct.editor,
          'publisher': _editedProduct.publisher,
          'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      } else
        titleAction = "Add Book";
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _cgstFocusNode.removeListener(_updateTotalGST);
    _sgstFocusNode.removeListener(_updateTotalGST);
    _igstFocusNode.removeListener(_updateTotalGST);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _cgstController.dispose();
    _sgstController.dispose();
    _igstController.dispose();
    _imageUrlFocusNode.dispose();
    _cgstFocusNode.dispose();
    _sgstFocusNode.dispose();
    _igstFocusNode.dispose();
    _hsnFocusNode.dispose();
    _uqmFocusNode.dispose();
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

  void _updateTotalGST() {
    //if (!_cgstFocusNode.hasFocus) {
    if (double.tryParse(_cgstController.text) != null &&
        double.tryParse(_sgstController.text) != null &&
        double.tryParse(_igstController.text) != null)
      _totalGst = double.parse(_cgstController.text) +
          double.parse(_sgstController.text) +
          double.parse(_igstController.text);
    print(_totalGst);
    setState(() {});
    // }
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
    if (_editedProduct.id != null) {
      await Provider.of<Books>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Books>(context, listen: false)
            .addProduct(_editedProduct);
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
                                .map((grades) => DropdownMenuItem(
                                      child: Text(grades),
                                      value: grades,
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
                              _editedProduct = Book(
                                  title: _editedProduct.title,
                                  grade: value,
                                  subject: _editedProduct.subject,
                                  description: _editedProduct.description,
                                  pages: _editedProduct.pages,
                                  editor: _editedProduct.editor,
                                  publisher: _editedProduct.publisher,
                                  imageUrl: _editedProduct.imageUrl,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite);
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
                                : grades[gradeValue]
                                    .map((grades) => DropdownMenuItem(
                                          child: Text(grades),
                                          value: grades,
                                        ))
                                    .toList(),
                            hint: Text('Subject'),
                            onChanged: (value) {
                              setState(() {
                                subjectValue = value;
                              });
                            },
                            onSaved: (value) {
                              _editedProduct = Book(
                                  title: _editedProduct.title,
                                  grade: _editedProduct.grade,
                                  subject: value,
                                  description: _editedProduct.description,
                                  pages: _editedProduct.pages,
                                  editor: _editedProduct.editor,
                                  publisher: _editedProduct.publisher,
                                  imageUrl: _editedProduct.imageUrl,
                                  id: _editedProduct.id,
                                  isFavorite: _editedProduct.isFavorite);
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
                            focusNode: _priceFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_cgstFocusNode);
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
                              _editedProduct = Book(
                                title: _editedProduct.title,
                                grade: _editedProduct.grade,
                                subject: _editedProduct.subject,
                                description: _editedProduct.description,
                                pages: int.parse(value),
                                editor: _editedProduct.editor,
                                publisher: _editedProduct.publisher,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
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
                            focusNode: _hsnFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_uqmFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter the editor of the book.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Book(
                                title: _editedProduct.title,
                                grade: _editedProduct.grade,
                                subject: _editedProduct.subject,
                                description: _editedProduct.description,
                                pages: _editedProduct.pages,
                                editor: value,
                                publisher: _editedProduct.publisher,
                                imageUrl: _editedProduct.imageUrl,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
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
                      focusNode: _uqmFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter publisher';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Book(
                          title: _editedProduct.title,
                          grade: _editedProduct.grade,
                          subject: _editedProduct.subject,
                          description: _editedProduct.description,
                          pages: _editedProduct.pages,
                          editor: _editedProduct.editor,
                          publisher: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    // Title
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Book(
                            title: value,
                            grade: _editedProduct.grade,
                            subject: _editedProduct.subject,
                            description: _editedProduct.description,
                            pages: _editedProduct.pages,
                            editor: _editedProduct.editor,
                            publisher: _editedProduct.publisher,
                            imageUrl: _editedProduct.imageUrl,
                            id: _editedProduct.id,
                            isFavorite: _editedProduct.isFavorite);
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
                        _editedProduct = Book(
                          title: _editedProduct.title,
                          grade: _editedProduct.grade,
                          subject: _editedProduct.subject,
                          description: value,
                          pages: _editedProduct.pages,
                          editor: _editedProduct.editor,
                          publisher: _editedProduct.publisher,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                              _editedProduct = Book(
                                title: _editedProduct.title,
                                grade: _editedProduct.grade,
                                subject: _editedProduct.subject,
                                description: _editedProduct.description,
                                pages: _editedProduct.pages,
                                editor: _editedProduct.editor,
                                publisher: _editedProduct.publisher,
                                imageUrl: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
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
