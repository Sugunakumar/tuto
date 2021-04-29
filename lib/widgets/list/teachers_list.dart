import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/models/models.dart';
import 'package:tuto/new_providers/school.dart';

import 'package:tuto/widgets/item/member_item.dart';

class TeachersTab extends StatelessWidget {
  final School loadedSchool;
  TeachersTab(this.loadedSchool, {Key key}) : super(key: key);

  //var classes;

  Future<void> _refreshProducts(BuildContext context) async {
    print('before failing teachers');
    await Provider.of<SchoolNotifier>(context, listen: false)
        .fetchAndSetTeachers();
    print('after failing');
    //await context.watch<SchoolNotifier>().fetchAndSetClasses();
    //classes = context.read<SchoolNotifier>().classes;
    //await loadedSchool.fetchAndSetClasses();
  }

  @override
  Widget build(BuildContext context) {
    //final loadedSchool = Provider.of<SchoolNotifier>(context, listen: false);
    final schoolData = Provider.of<SchoolNotifier>(context, listen: false);
    print('schoolData.teachers.length' + schoolData.teachers.length.toString());
    //final classesData = context.watch<SchoolNotifier>();

    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: schoolData.teachers.isEmpty
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
                  return TeachersList(schoolData.teachers);
                }
              })
          : TeachersList(schoolData.teachers),
    );
  }
}

class TeachersList extends StatelessWidget {
  final List<Teacher> entityItems;

  const TeachersList(this.entityItems, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //List<Teacher> teachers = Provider.of<SchoolNotifier>(context).teachers;
    print('teachers.length : ' + entityItems.length.toString());
    return entityItems.isNotEmpty
        ? ListView.builder(
            itemCount: entityItems.length,
            // itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
            //   value: teachers[i],
            //   child: EntityItem(),
            // ),
            itemBuilder: (ctx, i) => EntityItem(entityItems[i]),
          )
        : Center(
            child: Container(
              child: Text("Please add Teachers"),
            ),
          );
  }
}
