const tables = {
  'books': 'products',
  'chapters': 'chapters',
  'questions': 'questions',
  'users': 'users',
};

const grades = {
  'Grade 1': ['English Aplhabets', 'Coloring', 'Numbers'],
  'Grade 2': ['Maths', 'English', 'Numbers'],
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

enum Role { Student, Teacher, SchoolAdmin, Admin }

const permission = {
  Role.Admin: {
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
  Role.SchoolAdmin: {
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
