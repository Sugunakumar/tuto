import 'package:flutter/foundation.dart';
import '../models/question.dart';

class Chapter with ChangeNotifier {
  static final String tableName = 'chapters';

  final String id;
  final int index;
  final String title;

  List<Question> questions = [];

  Chapter({
    @required this.id,
    @required this.index,
    @required this.title,
  });
}
