import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const tables = {
  'books': 'products',
  'chapters': 'chapters',
  'questions': 'questions',
  'users': 'users',
  'schools': 'schools',
  'classes': 'classes',
  'students': 'students',
  'teachers': 'teachers',
  'tasks': 'tasks',
};

const schoolsTableName = "schools";
const classesTableName = "classes";
const booksTableName = "products";
const chaptersTableName = "chapters";
const subjectsTableName = "subjects";
const teachersTableName = "teachers";
const studentsTableName = "students";
const questionsTableName = "questions";
const membersTableName = "users";

final db = FirebaseFirestore.instance;

// The subjects must be remove from here and got from DB

const grades = {
  'Grade 1': ['English Aplhabets', 'Coloring', 'Numbers'],
  'Grade 2': ['Maths', 'English', 'Numbers'],
  'Grade 3': ['Maths', 'English', 'Social', 'Science', 'Computer'],
  'Grade 4': ['Maths', 'English', 'Social', 'Science', 'Computer'],
  'Grade 5': ['Maths', 'English', 'Social', 'Science', 'Computer'],
  'Grade 6': ['Maths', 'English', 'Social', 'Science', 'Computer'],
  'Grade 7': ['Maths', 'English', 'Social', 'Science', 'Computer'],
  'Grade 8': ['Maths', 'English', 'Social', 'Science', 'Computer'],
};

const questionType = ['Objective', 'Descriptive'];

const questionImportance = [
  'Least',
  'Maybe',
  'Most likely',
  'Important',
  'Must Know'
];

enum Entity { Book, Chapter, Question, School, User }

enum Operations { View, Add, Update, Delete }

enum Role { Individual, Student, Teacher, Admin, Manager }

const permission = {
  Role.Manager: {
    Entity.Book: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.Chapter: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.Question: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.School: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.User: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
  },
  Role.Admin: {
    Entity.School: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: false
    },
    Entity.Book: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.Chapter: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.Question: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.User: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
  },
  Role.Teacher: {
    Entity.Book: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.Chapter: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
    Entity.Question: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true
    },
  },
};

// one@test.com goodLuck
