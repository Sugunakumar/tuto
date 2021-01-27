import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/models/school.dart';
import 'package:tuto/providers/schools.dart';
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
              const Padding(padding: EdgeInsets.only(bottom: 2.0)),
              Text(
                '$board',
                style: const TextStyle(
                    //fontSize: 12.0,
                    //color: Colors.black54,
                    ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              address != null
                  ? Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 13,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5.0)),
                        Text(
                          '$address',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.0,
                            //color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const Padding(padding: EdgeInsets.only(bottom: 5.0)),
              Row(
                //crossAxisAlignment: CrossAxisAlignment.end, // top to bottom
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // left to right
                children: [
                  email != null
                      ? Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.email,
                              size: 13,
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5.0)),
                            Text(
                              '$email',
                              style: const TextStyle(
                                fontSize: 13.0,
                                //color: Colors.black87,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  phone != null
                      ? Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              size: 13,
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5.0)),
                            Text(
                              '$phone',
                              style: const TextStyle(
                                fontSize: 13.0,
                                //color: Colors.black87,
                              ),
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 5.0)),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({
    Key key,
    this.id,
    this.thumbnail,
    this.title,
    this.address,
    this.email,
    this.phone,
    this.board,
    this.role,
  }) : super(key: key);

  final String id;
  final Widget thumbnail;
  final String title;
  final String address;
  final String email;
  final String phone;
  final String board;
  final Role role;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5),
        child: InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(SchoolProfile.routeName, arguments: id);
          },
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
                  child: thumbnail,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 0.0, 2.0, 0.0),
                    child: _ArticleDescription(
                      title: title,
                      address: address,
                      email: email,
                      phone: phone,
                      board: board,
                    ),
                  ),
                ),
                role == Role.Manager
                    ? PopupMenuButton(
                        onSelected: (Operations value) async {
                          switch (value) {
                            case Operations.Update:
                              print('Admin  : ' +
                                  value.toString() +
                                  ' of school name ' +
                                  title);
                              Navigator.of(context).pushNamed(
                                  EditSchoolScreen.routeName,
                                  arguments: id);
                              break;
                            case Operations.Delete:
                              print('Admin  : ' +
                                  value.toString() +
                                  ' of school name ' +
                                  title);

                              try {
                                await schoolsData.delete(id);
                                Navigator.of(context).pop();
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

                              break;
                            default:
                          }
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
                      )
                    : role == Role.Admin
                        ? IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              print('edit  : ' + id);
                              Navigator.of(context).pushNamed(
                                  EditSchoolScreen.routeName,
                                  arguments: id);
                            },
                          )
                        : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class SchoolListTab extends StatelessWidget {
  SchoolListTab({Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Schools>(context, listen: false).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final schoolsData = Provider.of<Schools>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: schoolsData.items.isNotEmpty
          ? SchoolsListAgain()
          : FutureBuilder(
              future: schoolsData.fetchAndSet(),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  return Center(child: Text('An Error occured'));
                } else {
                  return SchoolsListAgain();
                }
              },
            ),
    );
  }
}

class SchoolsListAgain extends StatelessWidget {
  SchoolsListAgain();

  @override
  Widget build(BuildContext context) {
    return Consumer<Schools>(builder: (ctx, allItems, _) {
      final schools = allItems.items;

      return ListView.builder(
        itemCount: schools.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: schools[i],
          child: SchoolItem(),
        ),
      );
    });
  }
}

class SchoolItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final authData = Provider.of<Auth>(context, listen: false);
    final scaffold = Scaffold.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Consumer<School>(
        builder: (ctx, school, _) => CustomListItemTwo(
          id: school.id,
          thumbnail: school.imageURL.isNotEmpty
              ? Container(
                  child: FittedBox(
                    child: Image.network(
                      school.imageURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(),
          title: school.name,
          address: school.address,
          email: school.email,
          phone: school.phone,
          board: school.board,
          role: school.role,
        ),
      ),
    );
  }
}
