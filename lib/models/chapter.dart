import 'package:flutter/foundation.dart';

class Chapter with ChangeNotifier {
  final String id;
  final int index;
  final String title;

  Chapter({
    @required this.id,
    @required this.index,
    @required this.title,
  });
}
