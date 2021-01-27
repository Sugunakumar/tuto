import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question.dart';
import '../data/constants.dart';

class Questions with ChangeNotifier {
  final bookTable = tables['books'];
  final chapterTable = tables['chapters'];
  final questionTable = tables['questions'];

  String _chapterId;
  String _bookId;

  List<Question> _items = [];

  List<Question> get questions {
    return _items.toList();
  }

  // String get bookId {
  //   return this.bookId;
  // }

  // set bookId(String id) {
  //   this.bookId = id;
  // }

  Question findQuestionsById(String id) {
    return _items.firstWhere((ques) => ques.id == id);
  }

  Future<void> fetchAndSetQuestion(String bookId, String chapterId) async {
    print("fetchAndSetQuestion entry");
    this._bookId = bookId;
    this._chapterId = chapterId;
    final List<Question> loadedQuestions = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(bookTable)
          .doc(bookId)
          .collection(chapterTable)
          .doc(chapterId)
          .collection(questionTable)
          .get();

      print("fetchAndSetQuestion : " + snapshot.size.toString());

      if (snapshot.size == 0) {
        _items = [];
        return;
      }

      snapshot.docs.forEach((doc) {
        print("Questions : " + doc.data().toString());

        loadedQuestions.add(
          Question(
            id: doc.id,
            mark: doc.get('mark'),
            type: doc.get('type') == 'Objective'
                ? QuestionType.Objective
                : QuestionType.Descriptive,
            question: doc.get('question'),
            answer: doc.get('answer'),
            incorrectAnswers: doc.data().containsKey("incorrectAnswers")
                ? doc.get('incorrectAnswers')
                : null,
          ),
        );
      });
      _items = loadedQuestions;
      notifyListeners();
      print("fetchAndSetQuestion exit");
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addQuestion(Question question,
      {File questionImage, File answerImage}) async {
    final newQuestion = {
      'mark': question.mark,
      'type': question.type.toString().split('.').last,
      'question': question.question,
      'answer': question.answer,
      if (question.incorrectAnswers != null)
        'incorrectAnswers': FieldValue.arrayUnion(question.incorrectAnswers),
    };

    try {
      final questionCollection = FirebaseFirestore.instance
          .collection(bookTable)
          .doc(_bookId)
          .collection(chapterTable)
          .doc(_chapterId)
          .collection(questionTable);

      final addedProduct = await questionCollection.add(newQuestion);

      var questionUrl, answerUrl;

      if (questionImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('question_images')
            .child(addedProduct.id + '.jpg');

        await ref.putFile(questionImage).onComplete;

        questionUrl = await ref.getDownloadURL();
      }
      if (answerImage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('answer_images')
            .child(addedProduct.id + '.jpg');

        await ref.putFile(questionImage).onComplete;

        answerUrl = await ref.getDownloadURL();
      }
      if (questionUrl != null || answerUrl != null) {
        await questionCollection.doc(addedProduct.id).update({
          if (questionUrl != null) 'questionImageURL': questionUrl,
          if (answerUrl != null) 'answerImageURL': answerUrl,
        });
      }

      final newProductList = Question(
        id: addedProduct.id,
        mark: question.mark,
        type: question.type,
        question: question.question,
        answer: question.answer,
        incorrectAnswers: question.incorrectAnswers,
        questionImageURL: questionUrl,
        answerImageURL: answerUrl,
      );
      //_items.add(newProductList);
      _items.insert(0, newProductList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateQuestion(String id, Question newQuestion) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(bookTable)
            .doc(_bookId)
            .collection(chapterTable)
            .doc(_chapterId)
            .collection(questionTable)
            .doc(id)
            .update({
          'mark': newQuestion.mark,
          'type': newQuestion.type,
          'question': newQuestion.question,
          'answer': newQuestion.answer,
        });
        _items[prodIndex] = newQuestion;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('... No such Question with Id ' + id);
    }
  }

  Future<void> deleteQuestion(String id) async {
    final existingQuestionIndex = _items.indexWhere((prod) => prod.id == id);
    var existingQuestion = _items[existingQuestionIndex];
    _items.removeAt(existingQuestionIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(bookTable)
          .doc(_bookId)
          .collection(chapterTable)
          .doc(_chapterId)
          .collection(questionTable)
          .doc(id)
          .delete();
      existingQuestion = null;
    } catch (e) {
      _items.insert(existingQuestionIndex, existingQuestion);
      notifyListeners();
      throw e;
    }
  }
}
