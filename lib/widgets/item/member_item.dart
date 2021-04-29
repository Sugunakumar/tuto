import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tuto/models/models.dart';
import 'package:tuto/common/utils.dart';
import 'package:tuto/new_providers/school.dart';

class EntityItem extends StatelessWidget {
  final Teacher teacher;

  EntityItem(this.teacher, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: ListTile(
        leading: teacher.user.imageURL != null || teacher.user.imageURL == ""
            ? CircleAvatar(
                backgroundImage: NetworkImage(teacher.user.imageURL),
              )
            : CircleAvatar(
                child: Text(teacher.user.username[0].toUpperCase()),
              ),

        title: Text(teacher.user.username.inFirstLetterCaps),
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
                          teacher.user.username +
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
                              await Provider.of<SchoolNotifier>(context,
                                      listen: false)
                                  .removeTeacher(teacher.user.id);

                              scaffold.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    teacher.user.username + ' Deleted',
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
          color: Theme.of(context).buttonColor,
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
        onTap: () {
          // Navigator.of(context)
          //     .pushNamed(TeacherProfile.routeName, arguments: teacher.userId);
        },
      ),
    );
  }
}
