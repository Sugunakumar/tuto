import 'package:cloud_firestore/cloud_firestore.dart';

List<Role> getRoleByString(List<String> roleStr) {
  List<Role> roleRole = [];

  for (String item in roleStr) {
    switch (item) {
      case 'individual':
        roleRole.add(Role.Individual);
        break;
      case 'teacher':
        roleRole.add(Role.Teacher);
        break;
      case 'schoolAdmin':
        roleRole.add(Role.SchoolAdmin);
        break;
      case 'admin':
        roleRole.add(Role.Admin);
        break;
      case 'manager':
        roleRole.add(Role.Manager);
        break;
      default:
        roleRole.add(Role.Student);
    }
  }
  return roleRole;
}

Grade getGradeByString(String gradeStr) {
  return grades.keys
      .firstWhere((element) => element.toString().split('.').last == gradeStr);
}

String getStringByGrade(Grade grade) {
  return grade.toString().split('.').last;
}

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
const booksTableName = "books";
const chaptersTableName = "chapters";
const subjectsTableName = "subjects";
const teachersTableName = "teachers";
const adminsTableName = "admins";
const studentsTableName = "students";
const questionsTableName = "questions";
const membersTableName = "users";

final db = FirebaseFirestore.instance;

// The subjects must be remove from here and got from DB

const grades = {
  Grade.One: ['English Aplhabets', 'Coloring', 'Numbers'],
  Grade.Two: ['Maths', 'English', 'Numbers'],
  Grade.Three: ['Maths', 'English', 'Social', 'Science', 'Computer'],
  Grade.Four: ['Maths', 'English', 'Social', 'Science', 'Computer'],
  Grade.Five: ['Maths', 'English', 'Social', 'Science', 'Computer'],
  Grade.Six: ['Maths', 'English', 'Social', 'Science', 'Computer'],
  Grade.Seven: ['Maths', 'English', 'Social', 'Science', 'Computer'],
  Grade.Eight: ['Maths', 'English', 'Social', 'Science', 'Computer'],
};

const questionType = ['Objective', 'Descriptive'];

const questionImportance = [
  'Least',
  'Maybe',
  'Most likely',
  'Important',
  'Must Know'
];

enum Entity { Clazz, Teacher, Book, Chapter, Question, School, User }

enum Operations { View, Add, AddSchoolAdmin, Update, Delete }

enum Role { Individual, Student, Teacher, Admin, SchoolAdmin, Manager }

enum Grade { One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten }

// in db
// individual, student(default), teacher, admin, schoolAdmin, manager

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
    Entity.Teacher: {
      Operations.Add: true,
      Operations.AddSchoolAdmin: true,
      Operations.Update: true,
      Operations.Delete: true,
    },
    Entity.Clazz: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true,
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
  Role.SchoolAdmin: {
    Entity.School: {
      Operations.Add: false,
      Operations.Update: true,
      Operations.Delete: false
    },
    Entity.Teacher: {
      Operations.Add: true,
      Operations.AddSchoolAdmin: false,
      Operations.Update: true,
      Operations.Delete: true,
    },
    Entity.Clazz: {
      Operations.View: true,
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true,
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
    Entity.Teacher: {
      Operations.Add: true,
      Operations.AddSchoolAdmin: false,
      Operations.Update: true,
      Operations.Delete: true,
    },
    Entity.Clazz: {
      Operations.Add: false,
      Operations.Update: true,
      Operations.Delete: false,
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
  },
  Role.Individual: {
    Entity.School: {
      Operations.Add: true,
      Operations.Update: true,
      Operations.Delete: true,
      Operations.View: false,
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
  },
};

// one@test.com goodLuck
