// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../widgets/picker/box_image.dart';

// import '../../data/constants.dart';
// import '../../models/question.dart';

// import '../../providers/questions.dart';

// class EditQuestionScreen extends StatefulWidget {
//   static const routeName = '/edit-question';

//   @override
//   _EditQuestionScreenState createState() => _EditQuestionScreenState();
// }

// class _EditQuestionScreenState extends State<EditQuestionScreen> {
//   final _typeFocusNode = FocusNode();
//   final _importanceFocusNode = FocusNode();
//   final _markFocusNode = FocusNode();
//   final _questionFocusNode = FocusNode();
//   final _answerFocusNode = FocusNode();

  

//   final _form = GlobalKey<FormState>();

//   static List<String> friendsList = [null];

//   String titleAction = "Edit Question";

//   File _userImageFile;
//   void _pickedImage(File image) {
//     _userImageFile = image;
//   }

//   static var _editedQuestion = Question(
//     id: null,
//     mark: 0,
//     type: QuestionType.Objective,
//     question: '',
//     answer: '',
//     incorrectAnswers: friendsList,
//   );

//   var _initValues = {
//     'mark': '',
//     'type': '',
//     'question': '',
//     'answer': '',
//     'incorrectAnswers': [null],
//   };

//   var _isInit = true;
//   var _isLoading = false;

//   @override
//   void didChangeDependencies() {
//     if (_isInit) {
//       final chapterId = ModalRoute.of(context).settings.arguments as String;
//       // Edit
//       if (chapterId != null) {
//         //print("chapterId : " + chapterId);
//         _editedQuestion = Provider.of<Questions>(context, listen: false)
//             .findQuestionsById(chapterId);
//         _initValues = {
//           'mark': _editedQuestion.mark.toString(),
//           'type': _editedQuestion.type.toString().split('.').last,
//           'question': _editedQuestion.question,
//           'answer': _editedQuestion.answer,
//           'incorrectAnswers': _editedQuestion.incorrectAnswers,
//         };
//       } else // Add
//       {
//         friendsList = [null];
//         titleAction = "Add Question";
//       }
//     }
//     _isInit = false;
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     _typeFocusNode.dispose();
//     _importanceFocusNode.dispose();
//     _markFocusNode.dispose();
//     _questionFocusNode.dispose();
//     _answerFocusNode.dispose();
//     super.dispose();
//   }

//   Future<void> _saveForm() async {
//     final isValid = _form.currentState.validate();
//     if (!isValid) {
//       return;
//     }
//     _form.currentState.save();
//     setState(() {
//       _isLoading = true;
//     });
//     if (_editedQuestion.id != null) {
//       await Provider.of<Questions>(context, listen: false)
//           .updateQuestion(_editedQuestion.id, _editedQuestion);
//     } else {
//       try {
//         await Provider.of<Questions>(context, listen: false)
//             .addQuestion(_editedQuestion, questionImage: _userImageFile);
//       } catch (e) {
//         await showDialog<Null>(
//             context: context,
//             builder: (ctx) => AlertDialog(
//                   title: Text('An error occured!'),
//                   content: Text('Something went wrong'),
//                   actions: [
//                     FlatButton(
//                       child: Text('Okay'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     )
//                   ],
//                 ));
//       }
//       //  finally {
//       //   setState(() {
//       //     _isLoading = false;
//       //   });
//       //   Navigator.of(context).pop();
//       // }
//     }
//     setState(() {
//       _isLoading = false;
//     });
//     Navigator.of(context).pop();
//   }

//   String typeValue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(titleAction),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: _saveForm,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _form,
//                 child: ListView(
//                   children: <Widget>[
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: <Widget>[
//                         Expanded(
//                           child: DropdownButtonFormField<String>(
//                             value: typeValue,
//                             items: questionType
//                                 .map((type) => DropdownMenuItem(
//                                       child: Text(type),
//                                       value: type,
//                                     ))
//                                 .toList(),
//                             hint: Text('Type'),
//                             onChanged: (value) {
//                               setState(() {
//                                 typeValue = value;
//                               });
//                               FocusScope.of(context)
//                                   .requestFocus(_markFocusNode);
//                             },
//                             onSaved: (value) {
//                               _editedQuestion = Question(
//                                 mark: _editedQuestion.mark,
//                                 type: value == "Objective"
//                                     ? QuestionType.Objective
//                                     : QuestionType.Descriptive,
//                                 question: _editedQuestion.question,
//                                 answer: _editedQuestion.answer,
//                                 id: _editedQuestion.id,
//                               );
//                             },
//                           ),
//                           // UQM
//                         ),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: TextFormField(
//                             initialValue: _initValues['mark'],
//                             decoration: InputDecoration(labelText: 'Marks'),
//                             textInputAction: TextInputAction.next,
//                             keyboardType: TextInputType.number,
//                             focusNode: _markFocusNode,
//                             onFieldSubmitted: (_) {
//                               FocusScope.of(context)
//                                   .requestFocus(_questionFocusNode);
//                             },
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return 'Please enter index';
//                               }
//                               if (double.tryParse(value) == null) {
//                                 return 'Please enter a valid number.';
//                               }
//                               if (double.parse(value) <= 0) {
//                                 return 'Please enter a number greater than zero.';
//                               }
//                               return null;
//                             },
//                             onSaved: (value) {
//                               _editedQuestion = Question(
//                                 mark: int.parse(value),
//                                 type: _editedQuestion.type,
//                                 question: _editedQuestion.question,
//                                 answer: _editedQuestion.answer,
//                                 id: _editedQuestion.id,
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Question
//                     TextFormField(
//                       initialValue: _initValues['question'],
//                       decoration: InputDecoration(labelText: 'Question'),
//                       maxLines: 3,
//                       keyboardType: TextInputType.multiline,
//                       textInputAction: TextInputAction.next,
//                       focusNode: _questionFocusNode,
//                       onFieldSubmitted: (_) {
//                         FocusScope.of(context).requestFocus(_answerFocusNode);
//                       },
//                       validator: (value) {
//                         if (value.isEmpty) {
//                           return 'Please enter the question.';
//                         }
//                         // if (value.length < 10) {
//                         //   return 'Should be at least 10 characters long.';
//                         // }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editedQuestion = Question(
//                           mark: _editedQuestion.mark,
//                           type: _editedQuestion.type,
//                           question: value,
//                           answer: _editedQuestion.answer,
//                           id: _editedQuestion.id,
//                         );
//                       },
//                     ),
//                     // Question Image
//                     BoxImagePicker(_pickedImage),
//                     //UserImagePicker(_pickedImage),
//                     // Answer
//                     TextFormField(
//                       initialValue: _initValues['answer'],
//                       decoration: InputDecoration(labelText: 'Answer'),
//                       maxLines: 3,
//                       keyboardType: TextInputType.multiline,
//                       textInputAction: TextInputAction.next,
//                       focusNode: _answerFocusNode,
//                       onFieldSubmitted: (_) {
//                         _saveForm();
//                       },
//                       validator: (value) {
//                         if (value.trim().isEmpty)
//                           return 'Please enter the answer.';

//                         // if (value.length < 10) {
//                         //   return 'Should be at least 10 characters long.';
//                         // }
//                         return null;
//                       },
//                       onSaved: (value) {
//                         _editedQuestion = Question(
//                           mark: _editedQuestion.mark,
//                           type: _editedQuestion.type,
//                           question: _editedQuestion.question,
//                           answer: value,
//                           id: _editedQuestion.id,
//                         );
//                       },
//                     ),
//                     if (typeValue == "Objective") ..._getFriends(),
//                     FlatButton(
//                       onPressed: () {
//                         _saveForm();
//                       },
//                       child: Text('Submit'),
//                       color: Colors.blueAccent,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   List<Widget> _getFriends() {
//     List<Widget> friendsTextFields = [];
//     print("friendsList.length : " + friendsList.length.toString());
//     for (int i = 0; i < friendsList.length; i++) {
//       friendsTextFields.add(Padding(
//         padding: const EdgeInsets.symmetric(vertical: 16.0),
//         child: Row(
//           children: [
//             Expanded(child: FriendTextFields(i)),
//             SizedBox(
//               width: 16,
//             ),
//             // we need add button at last friends row
//             _addRemoveButton(i == friendsList.length - 1, i),
//           ],
//         ),
//       ));
//     }
//     return friendsTextFields;
//   }

//   /// add / remove button
//   Widget _addRemoveButton(bool add, int index) {
//     return InkWell(
//       onTap: () {
//         if (add) {
//           // add new text-fields at the top of all friends textfields
//           friendsList.insert(0, null);
//         } else
//           friendsList.removeAt(index);
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
//           _EditQuestionScreenState.friendsList[widget.index] ?? '';
//     });

//     return TextFormField(
//         controller: _nameController,
//         onChanged: (v) =>
//             _EditQuestionScreenState.friendsList[widget.index] = v,
//         decoration: InputDecoration(hintText: 'Incorrect answer'),
//         validator: (v) {
//           if (v.trim().isEmpty)
//             return 'Please enter an incorrect answer or remove the textfield';
//           return null;
//         },
//         onSaved: (value) {
//           _EditQuestionScreenState._editedQuestion = Question(
//             mark: _EditQuestionScreenState._editedQuestion.mark,
//             type: _EditQuestionScreenState._editedQuestion.type,
//             question: _EditQuestionScreenState._editedQuestion.question,
//             answer: _EditQuestionScreenState._editedQuestion.answer,
//             incorrectAnswers: _EditQuestionScreenState.friendsList,
//             id: _EditQuestionScreenState._editedQuestion.id,
//           );
//         });
//   }
// }
