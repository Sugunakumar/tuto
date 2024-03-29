import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tuto/new_providers/chapter.dart';
import 'package:tuto/new_providers/classChapter.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';

import '../../data/constants.dart';

import '../../providers/auth.dart';
//import '../../providers/chapters.dart';
import '../../screens/edit/edit_chapter.dart';

class ChapterItem extends StatelessWidget {
  final Chapter chapter;

  ChapterItem(this.chapter, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: ValueKey(chapter.id),
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
                .findClassById(ClassProfile.classId)
                .deleteClassBook(chapter.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  'Class ${chapter.title} deleted',
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
            //child: Text(chapter.grade.substring(chapter.grade.length - 1)),
            child: Text(chapter.index.toString()),
          ),
          title: Text(chapter.title),
          trailing: auth.currentMember.roles.contains(Role.SchoolAdmin)
              ? IconButton(
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).buttonColor,
                  onPressed: () => Navigator.of(context).pushNamed(
                      EditChapterScreen.routeName,
                      arguments: chapter.id),
                )
              : null,
          onTap: () {
            print('tapped chapter');
            //Navigator.of(context).pushNamed(ChapterProfile.routeName, arguments: chapter.id);
          },
        ),
      ),
    );
  }
}
