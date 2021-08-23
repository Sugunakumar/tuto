import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';

import 'package:tuto/new_providers/models.dart';
import 'package:tuto/new_providers/class.dart';

import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolStudent.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/edit/edit_schoolStudent.dart';
import 'package:tuto/screens/edit/edit_schoolTeacher.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';

class SchoolStudentItem extends StatelessWidget {
  final SchoolStudent schoolStudent;

  SchoolStudentItem(this.schoolStudent, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: ValueKey(schoolStudent.user.id),
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
                .removeStudent(schoolStudent.user.id);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Teacher ${schoolStudent.user.username} removed',
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
          leading: (schoolStudent.user.imageURL == null ||
                  schoolStudent.user.imageURL.isEmpty)
              ? CircleAvatar(
                  child: Text(schoolStudent.user.username[0].toUpperCase()),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(schoolStudent.user.imageURL)),

          title: Text(schoolStudent.user.username),
          subtitle: Text(schoolStudent.user.email),
          // onTap: () {
          //       Navigator.of(context)
          //           .pushNamed(SchoolProfile.routeName, arguments: school.id);
          //     },

          onLongPress: auth.currentMember.roles.contains(Role.SchoolAdmin)
              ? () {
                  Navigator.of(context).pushNamed(
                      EditSchoolStudentScreen.routeName,
                      arguments: schoolStudent.user.id);
                }
              : null,
        ),
      ),
    );
  }
}
