import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';

class ClassItem extends StatelessWidget {
  final Class clazz;

  ClassItem(this.clazz, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
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
        direction: auth.isSchoolAdmin(SchoolProfile.schoolId) || auth.isAdmin()
            ? DismissDirection.endToStart
            : null,
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
                .deleteClass(clazz.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Class ${clazz.name} deleted',
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
          leading: CircleAvatar(
            //child: Text(clazz.grade.substring(clazz.grade.length - 1)),
            child: Text(clazz.icon),
          ),
          title: Text(clazz.name),
          subtitle: clazz.classTeacher == null
              ? Text('Class Teacher Unassigned')
              : Text(clazz.classTeacher.user.username),
          trailing: auth.currentMember.roles.contains(Role.SchoolAdmin)
              ? IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).buttonColor,
                  onPressed: () => Navigator.of(context).pushNamed(
                      EditClassScreen.routeName,
                      arguments: clazz.id),
                )
              : null,
          onTap: auth.belongsToClass(clazz.id) ||
                  auth.isAdmin() ||
                  auth.isSchoolAdmin(SchoolProfile.schoolId)
              ? () {
                  print('tapped class');
                  Navigator.of(context)
                      .pushNamed(ClassProfile.routeName, arguments: clazz.id);
                }
              : null,
        ),
      ),
    );
  }
}
