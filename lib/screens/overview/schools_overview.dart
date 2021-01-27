import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/models/school.dart';
import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/screens/overview/home_page.dart';

import '../../data/constants.dart';
import '../../providers/auth.dart';

import '../../providers/schools.dart';
import '../../widgets/app_drawer.dart';

class SchoolOverviewScreen extends StatefulWidget {
  static const routeName = '/schools';

  @override
  _SchoolOverviewScreenState createState() => _SchoolOverviewScreenState();
}

class _SchoolOverviewScreenState extends State<SchoolOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final schoolsData = Provider.of<Schools>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Schools'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditSchoolScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: schoolsData.items.isNotEmpty
          ? SchoolsList()
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
                  return SchoolsList();
                }
              }),
    );
  }
}

class SchoolsList extends StatefulWidget {
  SchoolsList();

  @override
  _SchoolsListState createState() => _SchoolsListState();
}

class _SchoolsListState extends State<SchoolsList> {
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
        builder: (ctx, school, _) => ListTile(
          title: new Center(child: Text(school.name)),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                //if (authData.hasAccess(Entity.School, Operations.Update))
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditSchoolScreen.routeName,
                        arguments: school.id);
                  },
                  color: Theme.of(context).primaryColor,
                ),
                //if (authData.hasAccess(Entity.School, Operations.Delete))
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    try {
                      await Provider.of<Schools>(context, listen: false)
                          .delete(school.id);
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
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
          leading: school.imageURL == null || school.imageURL.isEmpty
              ? CircleAvatar(child: Text(school.name[0].toUpperCase()))
              : CircleAvatar(backgroundImage: NetworkImage(school.imageURL)),
          onTap: () {
            // Navigator.of(context)
            //     .pushNamed(SchoolDetailScreen.routeName, arguments: school.id);
          },
        ),
      ),
    );
  }
}
