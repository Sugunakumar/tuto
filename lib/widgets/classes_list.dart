import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/class.dart';

import 'package:tuto/providers/classes.dart';

import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/profile/class_profile.dart';

class ClassesList extends StatelessWidget {
  final List<Class> entityItems;

  const ClassesList({@required this.entityItems, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entityItems.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: entityItems[i],
        child: ClassItem(),
      ),
    );
  }
}

class ClassItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Consumer<Class>(
        builder: (ctx, clazz, _) => ListTile(
          leading: CircleAvatar(
            child: Text(clazz.grade.substring(clazz.grade.length - 1)),
          ),
          title: Text(clazz.name),
          subtitle: Text(clazz.classTeacher.name),
          trailing: PopupMenuButton(
            onSelected: (Operations selectedValue) async {
              if (selectedValue == Operations.Delete) {
                await showDialog<Null>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text('Delete Confirmation'),
                          content: Text('Are you sure to remove class \"' +
                              clazz.name +
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
                                  await Provider.of<Classes>(context,
                                          listen: false)
                                      .delete(clazz.id);

                                  scaffold.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        clazz.name + ' Deleted',
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
              } else if (selectedValue == Operations.Update) {
                Navigator.of(context)
                    .pushNamed(EditClassScreen.routeName, arguments: clazz.id);
              } else
                print(selectedValue);
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Edit'),
                value: Operations.Update,
              ),
              PopupMenuItem(
                child: Text('Delete'),
                value: Operations.Delete,
              ),
            ],
          ),

          //  Container(
          //   width: 100,
          //   child: Row(
          //     children: <Widget>[
          //       IconButton(
          //         icon: Icon(Icons.edit),
          //         onPressed: () {
          //           Navigator.of(context).pushNamed(EditChapterScreen.routeName,
          //               arguments: clazz.id);
          //         },
          //         color: Theme.of(context).primaryColor,
          //       ),
          //       IconButton(
          //         icon: Icon(Icons.delete),
          //         onPressed: () async {
          //           try {
          //             await Provider.of<Chapters>(context, listen: false)
          //                 .deleteChapter(clazz.id);
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
            Navigator.of(context)
                .pushNamed(ClassProfile.routeName, arguments: clazz.id);
          },
        ),
      ),
    );
  }
}
