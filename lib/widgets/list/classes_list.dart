import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tuto/new_providers/class.dart';

import 'package:tuto/new_providers/school.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/widgets/item/class_item.dart';

class ClassesTab extends StatelessWidget {
  final School loadedSchool;
  final bool isSearching;
  final String searchText;

  ClassesTab(this.loadedSchool, this.isSearching, this.searchText, {Key key})
      : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    await this.loadedSchool.fetchAndSetClasses(auth);
  }

  List<Class> loadClasses(BuildContext context) {
    if (isSearching)
      return loadedSchool.findClassByNamePattern(searchText);
    else
      return loadedSchool.classes;
  }

  @override
  Widget build(BuildContext context) {
    List<Class> classes = loadClasses(context);
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: classes.isEmpty
          ? FutureBuilder(
              future: _refreshProducts(context),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  print(dataSnapshot.error.toString());
                  return Center(child: Text('An Error occured'));
                } else {
                  return ClassesList(loadClasses(context));
                }
              })
          : ClassesList(classes),
    );
  }
}

class ClassesList extends StatelessWidget {
  final List<Class> entityItems;

  const ClassesList(this.entityItems, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return entityItems.isEmpty
        ? Center(
            child: Container(
              child: Text("Please add Teacher before creating a New class"),
            ),
          )
        : ListView.builder(
            itemCount: entityItems.length,
            itemBuilder: (ctx, i) => ClassItem(entityItems[i]),
          );
  }
}
