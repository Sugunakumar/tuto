import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/teacher.dart';
import '../providers/teachers.dart';
import '../common/utils.dart';

class TeachersList extends StatelessWidget {
  const TeachersList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Teacher> teachers = Provider.of<Teachers>(context).items;
    print('teachers.length : ' + teachers.length.toString());
    return teachers.isNotEmpty
        ? ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: teachers[i],
              child: EntityItem(),
            ),
          )
        : Center(
            child: Container(
              child: Text("Please add Teachers"),
            ),
          );
  }
}

class EntityItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Consumer<Teacher>(
        builder: (ctx, teacher, _) => ListTile(
          leading: teacher.imageURL != null || teacher.imageURL == ""
              ? CircleAvatar(
                  backgroundImage: NetworkImage(teacher.imageURL),
                )
              : CircleAvatar(
                  child: Text(teacher.name[0].toUpperCase()),
                ),

          title: Text(teacher.name.inCaps),
          //subtitle: Center(child: Text(teacher.grade)),
          // display the classes that teacher is involved with
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await showDialog<Null>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Delete Confirmation'),
                        content: Text('Are you sure to remove \"' +
                            teacher.name +
                            '\" form your school.'),
                        actions: [
                          FlatButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Yes'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              try {
                                await Provider.of<Teachers>(context,
                                        listen: false)
                                    .delete(teacher.userId);

                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      teacher.name + ' Deleted',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Deleting Failed',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ));
            },
            color: Theme.of(context).errorColor,
          ),

          // Container(
          //   width: 100,
          //   child: Row(
          //     children: <Widget>[
          //       // IconButton(
          //       //   icon: Icon(Icons.edit),
          //       //   onPressed: () {
          //       //     Navigator.of(context).pushNamed(EditTeacherScreen.routeName,
          //       //         arguments: teacher.userId);
          //       //   },
          //       //   color: Theme.of(context).primaryColor,
          //       // ),
          //       IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () async {
          //           try {
          //             await Provider.of<Teachers>(context, listen: false)
          //                 .delete(teacher.userId);
          //             scaffold.showSnackBar(
          //               SnackBar(
          //                 content: Text(
          //                   teacher.name + ' Deleted',
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             );
          //           } catch (e) {
          //             scaffold.showSnackBar(
          //               SnackBar(
          //                 content: Text(
          //                   'Deleting Failed',
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             );
          //           }
          //         },
          //         color: Theme.of(context).errorColor,
          //       ),
          //     ],
          //   ),
          // ),
          // onTap: () {
          //   // Navigator.of(context)
          //   //     .pushNamed(TeacherProfile.routeName, arguments: teacher.userId);
          // },
        ),
      ),
    );
  }
}
