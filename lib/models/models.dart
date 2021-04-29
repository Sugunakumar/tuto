import 'package:flutter/material.dart';

class School {
  final String id;
  final String name;
  final String address;
  String email;
  String phone;
  final String board;
  final String imageURL;
  List<String> teacherIds;
  List<String> studentIds;
  List<String> adminIds;

  School({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.board,
    @required this.imageURL,
    this.teacherIds,
    this.studentIds,
    this.adminIds,
    this.email,
    this.phone,
  });
}

class Class {
  final String id;
  final String name;
  final String grade;
  final String schoolId;
  final Teacher classTeacher;

  Class({
    this.schoolId,
    @required this.id,
    @required this.name,
    @required this.grade,
    this.classTeacher,
  });
}

class Book {
  final String id;
  final String grade;
  final String subject;
  final String title;
  final String description;
  final int pages;
  final String editor;
  final String publisher;
  final String imageUrl;
  final String classId;

  Book({
    this.classId,
    @required this.id,
    @required this.grade,
    @required this.subject,
    @required this.description,
    @required this.title,
    @required this.pages,
    @required this.editor,
    @required this.publisher,
    @required this.imageUrl,
  });
}

class Chapter {
  final String id;
  final int index;
  final String title;
  final String bookId;

  Chapter({
    this.bookId,
    @required this.id,
    @required this.index,
    @required this.title,
  });
}

enum QuestionType {
  Objective,
  Descriptive,
}

enum Approval { Approved, Rejected, Pending }

enum Importance { Least, Maybe, MostLikely, Important, Must }

class Question extends ChangeNotifier {
  final String id;
  final int mark;
  final QuestionType type;
  final String question;
  final String answer;
  final List<dynamic> incorrectAnswers;
  final String questionImageURL;
  final String answerImageURL;
  final String chapterId;

  Question({
    this.chapterId,
    @required this.id,
    @required this.mark,
    @required this.type,
    @required this.question,
    @required this.answer,
    this.incorrectAnswers,
    this.questionImageURL,
    this.answerImageURL,
  });
}

class Member {
  final String id;
  final String email;
  final String username;
  final String imageURL;

  Member({
    @required this.id,
    @required this.email,
    @required this.username,
    @required this.imageURL,
  });
}

class Student {
  final String schoolId;
  final Member user;

  Student({
    this.schoolId,
    @required this.user,
  });
}

class Teacher {
  final String schoolId;
  final Member user;

  Teacher({
    this.schoolId,
    @required this.user,
  });
}

enum TaskStatus { NotStarted, InProgress, Completed }

class Task {
  final String id;
  final String name;
  final TaskStatus status;
  final Member createdBy;
  final Member assignedTo;
  final DateTime assignedOn;
  DateTime completedOn;

  final String schoolId;
  final String classId;
  final String bookId;

  Task({
    @required this.id,
    @required this.name,
    this.createdBy,
    this.assignedOn,
    this.assignedTo,
    this.status = TaskStatus.NotStarted,
    this.schoolId,
    this.classId,
    this.bookId,
  });
}
