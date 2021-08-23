import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';

import 'package:tuto/new_providers/models.dart';
import 'package:tuto/new_providers/class.dart';

import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/edit/edit_schoolTeacher.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';

class SchoolTeacherItem extends StatelessWidget {
  final SchoolTeacher schoolTeacher;

  SchoolTeacherItem(this.schoolTeacher, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: ValueKey(schoolTeacher.user.id),
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
        direction: auth.currentMember.roles.contains(Role.SchoolAdmin)
            ? DismissDirection.endToStart
            : null,
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are you sure?'),
              content: Text(
                'Do you want to remove the Teacher from your school?',
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                TextButton(
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
            await Provider.of<Schools>(context, listen: false)
                .findById(SchoolProfile.schoolId)
                .removeTeacher(schoolTeacher.user.id);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Teacher ${schoolTeacher.user.username} removed',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
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
          leading: (schoolTeacher.user.imageURL == null ||
                  schoolTeacher.user.imageURL.isEmpty)
              ? CircleAvatar(
                  child: Text(schoolTeacher.user.username[0].toUpperCase()),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(schoolTeacher.user.imageURL)),

          title: Text(schoolTeacher.user.username),
          subtitle: Text(schoolTeacher.user.email),
          // onTap: () {
          //       Navigator.of(context)
          //           .pushNamed(SchoolProfile.routeName, arguments: school.id);
          //     },

          onLongPress: auth.currentMember.roles.contains(Role.SchoolAdmin)
              ? () {
                  Navigator.of(context).pushNamed(
                      EditSchoolTeacherScreen.routeName,
                      arguments: schoolTeacher.user.id);
                }
              : null,

          // trailing: auth.belongsToClass(clazz.id) &&
          //         auth.hasAccess(Entity.Clazz, Operations.Update)
          //     ? IconButton(
          //         icon: Icon(Icons.edit),
          //         //color: Theme.of(context).buttonColor,
          //         // onPressed: () => Navigator.of(context).pushNamed(
          //         //     EditClassScreen.routeName,
          //         //     arguments: clazz.id),

          //         // PopupMenuButton(
          //         //   onSelected: (Operations selectedValue) async {
          //         //     if (selectedValue == Operations.Delete) {
          //         //       await showDialog<Null>(
          //         //           context: context,
          //         //           builder: (ctx) => AlertDialog(
          //         //                 title: Text('Delete Confirmation'),
          //         //                 content: Text('Are you sure to remove class \"' +
          //         //                     clazz.name +
          //         //                     '\" form your school.'),
          //         //                 actions: [
          //         //                   FlatButton(
          //         //                     child: Text('No'),
          //         //                     onPressed: () {
          //         //                       Navigator.of(context).pop();
          //         //                     },
          //         //                   ),
          //         //                   FlatButton(
          //         //                     child: Text('Yes'),
          //         //                     onPressed: () async {
          //         //                       Navigator.of(context).pop();
          //         //                       try {
          //         //                         await Provider.of<SchoolNotifier>(context,
          //         //                                 listen: false)
          //         //                             .deleteClass(clazz.id);

          //         //                         scaffold.showSnackBar(
          //         //                           SnackBar(
          //         //                             content: Text(
          //         //                               clazz.name + ' Deleted',
          //         //                               textAlign: TextAlign.center,
          //         //                             ),
          //         //                           ),
          //         //                         );
          //         //                       } catch (e) {
          //         //                         scaffold.showSnackBar(
          //         //                           SnackBar(
          //         //                             content: Text(
          //         //                               'Deleting Failed',
          //         //                               textAlign: TextAlign.center,
          //         //                             ),
          //         //                           ),
          //         //                         );
          //         //                       }
          //         //                     },
          //         //                   )
          //         //                 ],
          //         //               ));
          //         //     } else if (selectedValue == Operations.Update) {
          //         //       Navigator.of(context)
          //         //           .pushNamed(EditClassScreen.routeName, arguments: clazz.id);
          //         //     } else
          //         //       print(selectedValue);
          //         //   },
          //         //   icon: Icon(
          //         //     Icons.more_vert,
          //         //   ),
          //         //   itemBuilder: (_) => [
          //         //     PopupMenuItem(
          //         //       child: Text('Edit'),
          //         //       value: Operations.Update,
          //         //     ),
          //         //     PopupMenuItem(
          //         //       child: Text('Delete'),
          //         //       value: Operations.Delete,
          //         //     ),
          //         //   ],
          //       )
          //     : null,
          // onTap: auth.belongsToClass(clazz.id) ||
          //         auth.hasAccess(Entity.Clazz, Operations.View)
          //     ? () {
          //         // context.read<ClassNotifier>().school = context.read<SchoolNotifier>().school;
          //         // context.read<ClassNotifier>().clazz = clazz;
          //         // Navigator.of(context).pushNamed(ClassProfile.routeName);
          //       }
          //     : null,
        ),
      ),
    );
  }
}
