import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/classBook.dart';

List<Book> classBookToFullBook(
    List<ClassBook> classBooks, List<Book> fullBooks) {
  List<Book> _books = [];
  if (classBooks != null)
    classBooks.forEach((classBook) {
      _books
          .add(fullBooks.firstWhere((fullbook) => fullbook.id == classBook.id));
    });
  return _books;
}
