import 'package:flutter/foundation.dart';
import 'package:tuto/data/constants.dart';

class OldSchool with ChangeNotifier {
  static final String tableName = 'schools';

  final String id;
  final String name;
  final String address;
  final String email;
  final String phone;
  final String board;
  final String imageURL;
  final Role role;

  OldSchool({
    @required this.id,
    @required this.name,
    @required this.address,
    @required this.board,
    @required this.imageURL,
    this.email,
    this.phone,
    this.role = Role.Individual,
  });
}
