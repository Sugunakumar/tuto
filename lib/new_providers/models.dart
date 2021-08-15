// import 'package:flutter/material.dart';
// import 'package:tuto/data/constants.dart';

// class MySchool {
//   final School school;
//   final List<Role> roles;
//   List<MyClass> classes;

//   MySchool({this.school, this.roles});
// }

// class MyClass {
//   final Class clazz;
//   final List<Role> roles;

//   MyClass({this.clazz, this.roles});
// }

// class ClassBook {
//   final String id;
//   final Book book;
//   List<ClassChapter> chapters;

//   ClassBook({@required this.id, @required this.book, this.chapters});
// }

// class ClassChapter {
//   final String id;
//   final Chapter chapter;
//   List<ClassQuestionAnswer> questions;

//   ClassChapter({@required this.id, @required this.chapter, this.questions});
// }

// class ClassQuestionAnswer {
//   final String id;
//   final Question question;
//   final Answer answer;

//   ClassQuestionAnswer({
//     @required this.id,
//     @required this.question,
//     @required this.answer,
//   });
// }

// // ===================== Books ========================

// // Teacher creates new Book
// // Teacher adds existing Books

// class Book {
//   final String id;
//   final String grade;
//   final String subject;
//   final String title;
//   final String description;
//   final int pages;
//   final String editor;
//   final String publisher;
//   final String imageUrl;
//   List<Chapter> chapters;

//   Book({
//     @required this.id,
//     @required this.grade,
//     @required this.subject,
//     @required this.description,
//     @required this.title,
//     @required this.pages,
//     @required this.editor,
//     @required this.publisher,
//     @required this.imageUrl,
//   });
// }

// class Chapter {
//   final String id;
//   final int index;
//   final String title;
//   List<Question> questions;
//   List<WorkBook> workbooks;

//   Chapter({@required this.id, @required this.index, @required this.title});
// }

// enum QuestionType { Objective, Descriptive }

// enum Approval { Approved, Rejected, Pending }

// enum Importance { Least, Maybe, MostLikely, Important, Must }

// class WorkBook {
//   final String id;
//   final List<Question> questions;

//   WorkBook({@required this.id, @required this.questions});
// }

// class Question {
//   final String id;
//   final int mark;
//   final QuestionType type;
//   final String question;
//   final List<Answer> answers;
//   final List<Answer> incorrectAnswers;
//   final String questionImageURL;

//   Question({
//     @required this.id,
//     @required this.mark,
//     @required this.type,
//     @required this.question,
//     this.answers,
//     this.incorrectAnswers,
//     this.questionImageURL,
//   });
// }

// class Answer {
//   final String id;
//   final String answer;
//   final String answerImageURL;

//   Answer({@required this.id, @required this.answer, this.answerImageURL});
// }

// class Student {
//   final String schoolId;
//   final Member user;

//   Student({
//     this.schoolId,
//     @required this.user,
//   });
// }

// enum TaskStatus { NotStarted, InProgress, Completed }

// class Task {
//   final String id;
//   final String name;
//   final TaskStatus status;
//   final Member createdBy;
//   final Member assignedTo;
//   final DateTime assignedOn;
//   DateTime completedOn;

//   final String schoolId;
//   final String classId;
//   final String bookId;

//   Task({
//     @required this.id,
//     @required this.name,
//     this.createdBy,
//     this.assignedOn,
//     this.assignedTo,
//     this.status = TaskStatus.NotStarted,
//     this.schoolId,
//     this.classId,
//     this.bookId,
//   });
// }
