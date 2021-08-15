import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/widgets/item/school_item.dart';

class SchoolListTab extends StatelessWidget {
  final bool isSearching;
  final String searchText;
  SchoolListTab(this.isSearching, this.searchText, {Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    final auth = context.watch<Auth>();
    final schoolProv = Provider.of<Schools>(context, listen: false);

    //auth.fetchAndSetMembers();
    // student // has schoolId  // has role sutdent

// fetches schools, it's classes and teachers.
// orderby shools belong to
    await schoolProv.fetchAndSetSchools(auth);
  }

  // List<School> loadSchools(BuildContext context) {
  //   final schoolData = Provider.of<Schools>(context, listen: false);
  //   if (isSearching)
  //     return schoolData.findSchoolsByName(searchText);
  //   else
  //     return schoolData.schools;
  // }

  @override
  Widget build(BuildContext context) {
    final schoolData = Provider.of<Schools>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: schoolData.schools.isNotEmpty
          ? SchoolsList(isSearching, searchText)
          : FutureBuilder(
              future: _refreshProducts(context),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  return Center(child: Text('An Error occured'));
                } else {
                  return SchoolsList(isSearching, searchText);
                }
              },
            ),
    );
  }
}

class SchoolsList extends StatefulWidget {
  final bool isSearching;
  final String searchText;
  SchoolsList(this.isSearching, this.searchText);

  @override
  _SchoolsListState createState() => _SchoolsListState();
}

class _SchoolsListState extends State<SchoolsList> {
  @override
  Widget build(BuildContext context) {
    var schools;
    return Consumer<Schools>(builder: (ctx, allItems, _) {
      if (widget.isSearching)
        schools = allItems.findSchoolsByName(widget.searchText);
      else
        schools = allItems.schools;

      return ListView.builder(
        itemCount: schools.length,
        itemBuilder: (ctx, i) => SchoolItem(schools[i]),
      );
    });
  }
}
