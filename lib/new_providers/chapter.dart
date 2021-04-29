import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/models.dart';

class ChapterNotifier with ChangeNotifier {
  School _school;
  Class _class;
  Book _book;
  Chapter _chapter;

  set school(School newSchool) {
    assert(newSchool != null);
    _school = newSchool;
    notifyListeners();
  }

  School get school => _school;

  set clazz(Class newClass) {
    assert(newClass != null);
    _class = newClass;
    notifyListeners();
  }

  Class get clazz => _class;

  set book(Book newBook) {
    assert(newBook != null);
    _book = newBook;
    notifyListeners();
  }

  Book get book => _book;

  set chapter(Chapter newChapter) {
    assert(newChapter != null);
    _chapter = newChapter;
    notifyListeners();
  }

  Chapter get chapter => _chapter;

  List<Question> _questions = [];

  List<Question> get questions {
    //return _questions.toList();
    return _questions.where((i) => i.chapterId == _chapter.id).toList();
  }

  Question findQuestionsById(String id) {
    return _questions.firstWhere((ques) => ques.id == id);
  }

  Future<void> fetchAndSetQuestion() async {
    print("fetchAndSetQuestion entry");

    final List<Question> loadedQuestions = [];
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(_book.id)
          .collection(chaptersTableName)
          .doc(_chapter.id)
          .collection(questionsTableName)
          .get();

      print("fetchAndSetQuestion : " + snapshot.size.toString());

      if (snapshot.size == 0) {
        _questions = [];
        return;
      }

      snapshot.docs.forEach((doc) {
        print("Questions : " + doc.data().toString());

        loadedQuestions.add(
          Question(
            chapterId: _chapter.id,
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
      _questions = loadedQuestions;
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
          .collection(booksTableName)
          .doc(_book.id)
          .collection(chaptersTableName)
          .doc(_chapter.id)
          .collection(questionsTableName);

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
      //_questions.add(newProductList);
      _questions.insert(0, newProductList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateQuestion(String id, Question newQuestion) async {
    final prodIndex = _questions.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(booksTableName)
            .doc(_book.id)
            .collection(chaptersTableName)
            .doc(_chapter.id)
            .collection(questionsTableName)
            .doc(id)
            .update({
          'mark': newQuestion.mark,
          'type': newQuestion.type,
          'question': newQuestion.question,
          'answer': newQuestion.answer,
        });
        _questions[prodIndex] = newQuestion;
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
    final existingQuestionIndex =
        _questions.indexWhere((prod) => prod.id == id);
    var existingQuestion = _questions[existingQuestionIndex];
    _questions.removeAt(existingQuestionIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(booksTableName)
          .doc(_book.id)
          .collection(chaptersTableName)
          .doc(_chapter.id)
          .collection(questionsTableName)
          .doc(id)
          .delete();
      existingQuestion = null;
    } catch (e) {
      _questions.insert(existingQuestionIndex, existingQuestion);
      notifyListeners();
      throw e;
    }
  }
}
