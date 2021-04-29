import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';

import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/screens/profile/school_profile.dart';

class _ArticleDescription extends StatelessWidget {
  _ArticleDescription({
    Key key,
    this.title,
    this.address,
    this.email,
    this.phone,
    this.board,
  }) : super(key: key);

  final String title;
  final String address;
  final String email;
  final String phone;
  final String board;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // left to right
            //mainAxisAlignment: MainAxisAlignment.end, // top to bottom
            children: <Widget>[
              Text(
                '$title',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 4.0)),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 15,
                  ),
                  const Padding(padding: EdgeInsets.only(right: 5.0)),
                  Text(
                    '$board',
                    style: const TextStyle(
                        //fontSize: 12.0,
                        //color: Colors.black54,
                        ),
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 4.0)),
              address != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 15,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5.0)),
                        Text(
                          '$address',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              //fontSize: 13.0,
                              //color: Colors.black54,
                              ),
                        ),
                      ],
                    )
                  : Container(),
              const Padding(padding: EdgeInsets.only(bottom: 4.0)),
              email != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.alternate_email,
                          size: 15,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5.0)),
                        Text(
                          '$email',
                          style: const TextStyle(
                              //fontSize: 13.0,
                              //color: Colors.black87,
                              ),
                        ),
                      ],
                    )
                  : Container(),
              const Padding(padding: EdgeInsets.only(bottom: 4.0)),
              phone != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.phone_android,
                          size: 15,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5.0)),
                        Text(
                          '$phone',
                          style: const TextStyle(
                              //fontSize: 13.0,
                              //color: Colors.black87,
                              ),
                        ),
                      ],
                    )
                  : Container(),
              const Padding(padding: EdgeInsets.only(bottom: 4.0)),
            ],
          ),
        ),
        // Expanded(
        //   flex: 3,
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       //const Padding(padding: EdgeInsets.only(bottom: 5.0)),
        //       Row(
        //         //crossAxisAlignment: CrossAxisAlignment.end, // top to bottom
        //         mainAxisAlignment:
        //             MainAxisAlignment.spaceBetween, // left to right
        //         children: [

        //         ],
        //       ),
        //       const Padding(padding: EdgeInsets.only(bottom: 5.0)),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}

class CardActionButtons extends StatelessWidget {
  const CardActionButtons({
    Key key,
    @required this.school,
  }) : super(key: key);

  final School school;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            print('edit  : ' + school.id);
            Navigator.of(context)
                .pushNamed(EditSchoolScreen.routeName, arguments: school.id);
          },
        ),
      ],
    );
  }
}

class SchoolItem extends StatelessWidget {
  final School school;
  SchoolItem(this.school, {Key key}) : super(key: key);
  //SchoolItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User currentUser = context.watch<Auth>().fetchCurrentUser();
    final bool isStudent =
        context.watch<Schools>().isStudent(school.id, currentUser.uid);
    print(school.name + ' isStudent  ' + isStudent.toString());
    final bool isTeacher =
        context.watch<Schools>().isTeacher(school.id, currentUser.uid);
    print(school.name + ' isTeacher  ' + isTeacher.toString());
    final bool isAdmin = context.watch<Auth>().isAdmin();
    print('isAdmin  ' + isAdmin.toString());

    final bool belongsToSchool = isStudent || isTeacher ? true : false;

    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Dismissible(
        key: ValueKey(school.id),
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
          if (isAdmin)
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: Text('Are you sure?'),
                content: Text(
                  'Do you want to remove the school from the list?',
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
          else
            return null;
        },
        onDismissed: (direction) async {
          try {
            await Provider.of<Schools>(context, listen: false)
                .delete(school.id);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'School deleted',
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
        child: Card(
          elevation: 3,
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
            child: InkWell(
              onTap: () {
                context.read<SchoolNotifier>().school = school;
                Navigator.of(context).pushNamed(SchoolProfile.routeName);
              },
              // onLongPress: () {
              //   print('edit  : ' + school.id);
              //   Navigator.of(context)
              //       .pushNamed(EditSchoolScreen.routeName, arguments: school.id);
              // },
              // Generally, material cards use onSurface with 12% opacity for the pressed state.
              splashColor:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
              // Generally, material cards do not have a highlight overlay.
              highlightColor: Colors.transparent,
              child: SizedBox(
                height: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Container(
                        child: school.imageURL != null
                            ? FittedBox(
                                child: Image.network(
                                  school.imageURL,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 0.0, 4.0, 0.0),
                        child: _ArticleDescription(
                          title: school.name,
                          address: school.address,
                          email: school.email,
                          phone: school.phone,
                          board: school.board,
                        ),
                      ),
                    ),
                    if (belongsToSchool || isAdmin)
                      CardActionButtons(school: school),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      //),
    );
  }
}
