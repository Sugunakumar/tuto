import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/models/subject.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/providers/classProvider.dart';

import '../models/subject.dart';
import '../common/utils.dart';

// class SubjectsList extends StatelessWidget {
//   const SubjectsList({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Subject> subjects = Provider.of<ClassNotifier>(context).subjects;
//     print('subjects.length : ' + subjects.length.toString());
//     return subjects.isNotEmpty
//         ? ListView.builder(
//             itemCount: subjects.length,
//             itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
//               value: subjects[i],
//               child: EntityItem(),
//             ),
//           )
//         : Center(
//             child: Container(
//               child: Text("Please add Subjects"),
//             ),
//           );
//   }
// }

// class EntityItem extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final scaffold = Scaffold.of(context);
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(10),
//       child: Consumer<Subject>(
//         builder: (ctx, subject, _) => ListTile(
//           title: Text(subject.name.inCaps),
//           //subtitle: Center(child: Text(subject.grade)),
//           // display the classes that subject is involved with
//           trailing: IconButton(
//             icon: Icon(Icons.delete),
//             onPressed: () async {
//               await showDialog<Null>(
//                   context: context,
//                   builder: (ctx) => AlertDialog(
//                         title: Text('Delete Confirmation'),
//                         content: Text('Are you sure to remove \"' +
//                             subject.name +
//                             '\" form your school.'),
//                         actions: [
//                           FlatButton(
//                             child: Text('No'),
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                           ),
//                           FlatButton(
//                             child: Text('Yes'),
//                             onPressed: () async {
//                               Navigator.of(context).pop();
//                               try {
//                                 // await Provider.of<ClassProvider>(context,
//                                 //         listen: false)
//                                 //     .deleteStudent(subject.userId);

//                                 scaffold.showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       subject.name + ' Deleted',
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 );
//                               } catch (e) {
//                                 scaffold.showSnackBar(
//                                   SnackBar(
//                                     content: Text(
//                                       'Deleting Failed',
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 );
//                               }
//                             },
//                           )
//                         ],
//                       ));
//             },
//             color: Theme.of(context).errorColor,
//           ),
//         ),
//       ),
//     );
//   }
// }
