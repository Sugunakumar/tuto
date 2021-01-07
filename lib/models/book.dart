import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './../data/constants.dart';

final bookTable = tables['books'];
final userTable = tables['users'];

class Book with ChangeNotifier {
  final String id;
  final String grade;
  final String subject;
  final String title;
  final String description;
  final int pages;
  final String editor;
  final String publisher;
  final String imageUrl;
  bool isFavorite;

  Book({
    @required this.id,
    @required this.grade,
    @required this.subject,
    @required this.description,
    @required this.title,
    @required this.pages,
    @required this.editor,
    @required this.publisher,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    print("toggleFavoriteStatus");
    notifyListeners();
    try {
      if (isFavorite)
        await FirebaseFirestore.instance
            .collection(userTable)
            .doc(userId)
            .update({
          'favorites': FieldValue.arrayUnion([id]),
        });
      else
        await FirebaseFirestore.instance
            .collection(userTable)
            .doc(userId)
            .update({
          'favorites': FieldValue.arrayRemove([id]),
        });
    } catch (e) {
      isFavorite = oldStatus;
      notifyListeners();
      print(e);
    }
  }
}
