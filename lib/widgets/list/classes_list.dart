import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/widgets/item/classes_item.dart';

class ClassesTab extends StatelessWidget {
  final School loadedSchool;
  ClassesTab(this.loadedSchool, {Key key}) : super(key: key);

  //var classes;

  Future<void> _refreshProducts(BuildContext context) async {
    print('before failing class');
    await Provider.of<SchoolNotifier>(context, listen: false)
        .fetchAndSetClasses();
    print('after failing');
    //await context.watch<SchoolNotifier>().fetchAndSetClasses();
    //classes = context.read<SchoolNotifier>().classes;
    //await loadedSchool.fetchAndSetClasses();
  }

  @override
  Widget build(BuildContext context) {
    //final loadedSchool = Provider.of<SchoolNotifier>(context, listen: false);
    final classesData = Provider.of<SchoolNotifier>(context, listen: false);
    //final classesData = context.watch<SchoolNotifier>();

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: classesData.classes.isEmpty
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
                  return ClassesList(classesData.classes);
                }
              })
          : ClassesList(classesData.classes),
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
              child: Text("Please add Classes"),
            ),
          )
        : ListView.builder(
            itemCount: entityItems.length,
            // itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            //   value: entityItems[i],
            //   child: ClassItem(),
            // ),
            itemBuilder: (ctx, i) => ClassItem(entityItems[i]),
          );
  }
}
