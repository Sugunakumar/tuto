import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/chapter.dart';
import 'package:tuto/new_providers/classBook.dart';
import 'package:tuto/new_providers/classChapter.dart';

List<Book> classBookToFullBook(
    List<ClassBook> classBooks, List<Book> fullBooks) {
  List<Book> _books = [];
  if (classBooks != null)
    classBooks.forEach((classBook) {
      Book bk = fullBooks.firstWhere((fullbook) => fullbook.id == classBook.id,
          orElse: null);
      if (bk != null) _books.add(bk);
    });
  return _books;
}

List<Chapter> classChapterToFullChapter(
    List<ClassChapter> classChapters, List<Chapter> fullChapters) {
  List<Chapter> _chapter = [];
  if (classChapters != null)
    classChapters.forEach((classChapter) {
      Chapter chap = fullChapters.firstWhere((fullChapter) => fullChapter.id == classChapter.id,
          orElse: null);
      if (chap != null) _chapter.add(chap);
    });
  return _chapter;
}



