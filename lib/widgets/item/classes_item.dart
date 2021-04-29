import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';

import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/class.dart';

import 'package:tuto/new_providers/school.dart';

import 'package:tuto/providers/schoolProvider.dart';

import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/profile/class_profile.dart';

class ClassItem extends StatelessWidget {
  final Class clazz;

  ClassItem(this.clazz, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: ValueKey(clazz.id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          //if (isAdmin)
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Do you want to remove the Class from your school?',
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
          // else
          //   return null;
        },
        onDismissed: (direction) async {
          try {
            await Provider.of<SchoolNotifier>(context, listen: false)
                .deleteClass(clazz.id);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Class ${clazz.name} deleted',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } catch (e) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Deleting Failed',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            //child: Text(clazz.grade.substring(clazz.grade.length - 1)),
            child: Text(clazz.name),
          ),
          title: Text(clazz.classTeacher.user.username),
          //subtitle: Text(clazz.classTeacher.user.username),
          trailing: IconButton(
            icon: Icon(Icons.edit),
            //color: Theme.of(context).buttonColor,
            onPressed: () => Navigator.of(context)
                .pushNamed(EditClassScreen.routeName, arguments: clazz.id),

            // PopupMenuButton(
            //   onSelected: (Operations selectedValue) async {
            //     if (selectedValue == Operations.Delete) {
            //       await showDialog<Null>(
            //           context: context,
            //           builder: (ctx) => AlertDialog(
            //                 title: Text('Delete Confirmation'),
            //                 content: Text('Are you sure to remove class \"' +
            //                     clazz.name +
            //                     '\" form your school.'),
            //                 actions: [
            //                   FlatButton(
            //                     child: Text('No'),
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     },
            //                   ),
            //                   FlatButton(
            //                     child: Text('Yes'),
            //                     onPressed: () async {
            //                       Navigator.of(context).pop();
            //                       try {
            //                         await Provider.of<SchoolNotifier>(context,
            //                                 listen: false)
            //                             .deleteClass(clazz.id);

            //                         scaffold.showSnackBar(
            //                           SnackBar(
            //                             content: Text(
            //                               clazz.name + ' Deleted',
            //                               textAlign: TextAlign.center,
            //                             ),
            //                           ),
            //                         );
            //                       } catch (e) {
            //                         scaffold.showSnackBar(
            //                           SnackBar(
            //                             content: Text(
            //                               'Deleting Failed',
            //                               textAlign: TextAlign.center,
            //                             ),
            //                           ),
            //                         );
            //                       }
            //                     },
            //                   )
            //                 ],
            //               ));
            //     } else if (selectedValue == Operations.Update) {
            //       Navigator.of(context)
            //           .pushNamed(EditClassScreen.routeName, arguments: clazz.id);
            //     } else
            //       print(selectedValue);
            //   },
            //   icon: Icon(
            //     Icons.more_vert,
            //   ),
            //   itemBuilder: (_) => [
            //     PopupMenuItem(
            //       child: Text('Edit'),
            //       value: Operations.Update,
            //     ),
            //     PopupMenuItem(
            //       child: Text('Delete'),
            //       value: Operations.Delete,
            //     ),
            //   ],
          ),
          onTap: () {
            // context.read<ClassNotifier>().school = context.read<SchoolNotifier>().school;
            context.read<ClassNotifier>().clazz = clazz;
            Navigator.of(context).pushNamed(ClassProfile.routeName);
          },
        ),
      ),
    );
  }
}
