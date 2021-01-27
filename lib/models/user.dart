import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/constants.dart';

class CurrentUser with ChangeNotifier {
  final String id;
  final String email;
  final String username;
  final String imageURL;

  CurrentUser({
    @required this.id,
    @required this.email,
    @required this.username,
    @required this.imageURL,
  });
}
