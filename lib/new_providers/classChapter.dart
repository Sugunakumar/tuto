import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/classQuestion.dart';
import 'package:tuto/new_providers/question.dart';

class ClassChapter with ChangeNotifier {
  final String id;

  List<ClassQuestion> _questions;
  //List<WorkBook> workbooks;

  ClassChapter({
    @required this.id,
  });

  List<ClassQuestion> get questions => _questions;

  // List<Question> get questions {
  //   //return _questions.toList();
  //   return _questions.where((i) => i.chapterId == _chapter.id).toList();
  // }

  // Question findQuestionsById(String id) {
  //   return _questions.firstWhere((ques) => ques.id == id);
  // }

  // Future<void> fetchAndSetQuestion(String bookId) async {
  //   print("fetchAndSetQuestion entry");

  //   final List<Question> loadedQuestions = [];
  //   try {
  //     final snapshot = await FirebaseFirestore.instance
  //         .collection(booksTableName)
  //         .doc(bookId)
  //         .collection(chaptersTableName)
  //         .doc(id)
  //         .collection(questionsTableName)
  //         .get();

  //     print("fetchAndSetQuestion : " + snapshot.size.toString());

  //     if (snapshot.size == 0) {
  //       _questions = [];
  //       return;
  //     }

  //     snapshot.docs.forEach((doc) {
  //       print("Questions : " + doc.data().toString());

  //       loadedQuestions.add(
  //         Question(
  //           //chapterId: _chapter.id,
  //           id: doc.id,
  //           mark: doc.get('mark'),
  //           type: doc.get('type') == 'Objective'
  //               ? QuestionType.Objective
  //               : QuestionType.Descriptive,
  //           question: doc.get('question'),
  //           questionImageURL: doc.get('questionImageURL'),
  //         ),
  //       );
  //     });
  //     _questions = loadedQuestions;
  //     notifyListeners();
  //     print("fetchAndSetQuestion exit");
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  // Future<void> addQuestion(Question question, String bookId,
  //     {File questionImage, File answerImage}) async {
  //   final newQuestion = {
  //     'mark': question.mark,
  //     'type': question.type.toString().split('.').last,
  //     'question': question.question,
  //     'answers': question.answers,
  //     // if (question.incorrectAnswers != null)
  //     //   'incorrectAnswers': FieldValue.arrayUnion(question.incorrectAnswers),
  //   };

  //   try {
  //     final questionCollection = FirebaseFirestore.instance
  //         .collection(booksTableName)
  //         .doc(bookId)
  //         .collection(chaptersTableName)
  //         .doc(id)
  //         .collection(questionsTableName);

  //     final addedProduct = await questionCollection.add(newQuestion);

  //     var questionUrl, answerUrl;

  //     if (questionImage != null) {
  //       final ref = FirebaseStorage.instance
  //           .ref()
  //           .child('question_images')
  //           .child(addedProduct.id + '.jpg');

  //       await ref.putFile(questionImage).whenComplete(() => null);

  //       questionUrl = await ref.getDownloadURL();
  //     }
  //     if (answerImage != null) {
  //       final ref = FirebaseStorage.instance
  //           .ref()
  //           .child('answer_images')
  //           .child(addedProduct.id + '.jpg');

  //       await ref.putFile(questionImage).whenComplete(() => null);

  //       answerUrl = await ref.getDownloadURL();
  //     }
  //     if (questionUrl != null || answerUrl != null) {
  //       await questionCollection.doc(addedProduct.id).update({
  //         if (questionUrl != null) 'questionImageURL': questionUrl,
  //         if (answerUrl != null) 'answerImageURL': answerUrl,
  //       });
  //     }

  //     final newProductList = Question(
  //       id: addedProduct.id,
  //       mark: question.mark,
  //       type: question.type,
  //       question: question.question,
  //       questionImageURL: questionUrl,
  //       //answerImageURL: answerUrl,
  //     );
  //     //_questions.add(newProductList);
  //     _questions.insert(0, newProductList);
  //     notifyListeners();
  //   } catch (e) {
  //     print(e);
  //     throw e;
  //   }
  // }

  // Future<void> updateQuestion(
  //     String bookId, String chapterId, Question newQuestion) async {
  //   final prodIndex = _questions.indexWhere((prod) => prod.id == id);
  //   if (prodIndex >= 0) {
  //     try {
  //       await FirebaseFirestore.instance
  //           .collection(booksTableName)
  //           .doc(bookId)
  //           .collection(chaptersTableName)
  //           .doc(id)
  //           .collection(questionsTableName)
  //           .doc(chapterId)
  //           .update({
  //         'mark': newQuestion.mark,
  //         'type': newQuestion.type,
  //         'question': newQuestion.question,
  //         'answer': newQuestion.answers,
  //       });
  //       _questions[prodIndex] = newQuestion;
  //       notifyListeners();
  //     } catch (e) {
  //       print(e);
  //       throw e;
  //     }
  //   } else {
  //     print('... No such Question with Id ' + id);
  //   }
  // }

  // Future<void> deleteQuestion(String bookId, String chapterId) async {
  //   final existingQuestionIndex =
  //       _questions.indexWhere((prod) => prod.id == id);
  //   var existingQuestion = _questions[existingQuestionIndex];
  //   _questions.removeAt(existingQuestionIndex);
  //   notifyListeners();

  //   try {
  //     await FirebaseFirestore.instance
  //         .collection(booksTableName)
  //         .doc(bookId)
  //         .collection(chaptersTableName)
  //         .doc(id)
  //         .collection(questionsTableName)
  //         .doc(chapterId)
  //         .delete();
  //     existingQuestion = null;
  //   } catch (e) {
  //     _questions.insert(existingQuestionIndex, existingQuestion);
  //     notifyListeners();
  //     throw e;
  //   }
  // }
}
