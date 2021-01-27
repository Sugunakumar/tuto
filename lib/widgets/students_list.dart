import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../providers/students.dart';
import '../common/utils.dart';

class StudentsList extends StatelessWidget {
  const StudentsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Student> students = Provider.of<Students>(context).items;
    print('students.length : ' + students.length.toString());
    return students.isNotEmpty
        ? ListView.builder(
            itemCount: students.length,
            itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: students[i],
              child: EntityItem(),
            ),
          )
        : Center(
            child: Container(
              child: Text("Please add Students"),
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
      child: Consumer<Student>(
        builder: (ctx, student, _) => ListTile(
          leading: student.imageURL != null || student.imageURL == ""
              ? CircleAvatar(
                  backgroundImage: NetworkImage(student.imageURL),
                )
              : CircleAvatar(
                  child: Text(student.name[0].toUpperCase()),
                ),

          title: Text(student.name.inCaps),
          //subtitle: Center(child: Text(student.grade)),
          // display the classes that student is involved with
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await showDialog<Null>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                        title: Text('Delete Confirmation'),
                        content: Text('Are you sure to remove \"' +
                            student.name +
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
                                await Provider.of<Students>(context,
                                        listen: false)
                                    .delete(student.userId);

                                scaffold.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      student.name + ' Deleted',
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
        ),
      ),
    );
  }
}
