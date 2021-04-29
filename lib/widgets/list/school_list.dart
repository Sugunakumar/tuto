import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/widgets/item/school_item.dart';

class SchoolListTab extends StatelessWidget {
  final bool isSearching;
  final String searchText;
  SchoolListTab(this.isSearching, this.searchText, {Key key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Schools>(context, listen: false).fetchAndSet();
  }

  @override
  Widget build(BuildContext context) {
    final schoolsData = Provider.of<Schools>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: schoolsData.items.isNotEmpty
          ? SchoolsListAgain(isSearching, searchText)
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
                  return SchoolsListAgain(isSearching, searchText);
                }
              },
            ),
    );
  }
}

class SchoolsListAgain extends StatefulWidget {
  final bool isSearching;
  final String searchText;
  SchoolsListAgain(this.isSearching, this.searchText);

  @override
  _SchoolsListAgainState createState() => _SchoolsListAgainState();
}

class _SchoolsListAgainState extends State<SchoolsListAgain> {
  @override
  Widget build(BuildContext context) {
    var schools;
    return Consumer<Schools>(builder: (ctx, allItems, _) {
      if (widget.isSearching)
        schools = allItems.findSchoolsByName(widget.searchText);
      else
        schools = allItems.items;

      return ListView.builder(
        itemCount: schools.length,
        itemBuilder: (ctx, i) => SchoolItem(schools[i]),
      );
    });
  }
}
