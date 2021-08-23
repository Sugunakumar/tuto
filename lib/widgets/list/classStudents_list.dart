import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/data/constants.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/widgets/item/schoolTeacher_item.dart';

class ClassStudentsTab extends StatelessWidget {
  final Class loadedClass;
  final bool isSearching;
  final String searchText;

  ClassStudentsTab(this.loadedClass, this.isSearching, this.searchText,
      {Key key})
      : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    // fetch and set Members
    final auth = Provider.of<Auth>(context, listen: false);
    await auth.fetchAndSetMembers();
    // fetch and set School Teachers
    //await this.loadedClass.fetchAndSetStudents();
    print("refresh called");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: loadedClass.students.isEmpty
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
                  return StudentsList(loadedClass, isSearching, searchText);
                }
              })
          : StudentsList(loadedClass, isSearching, searchText),
    );
  }
}

class StudentsList extends StatefulWidget {
  final Class loadedClass;
  final bool isSearching;
  final String searchText;

  const StudentsList(this.loadedClass, this.isSearching, this.searchText,
      {Key key})
      : super(key: key);

  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  @override
  Widget build(BuildContext context) {
    var teachers;
    if (widget.isSearching)
      //teachers = widget.loadedClass.findTeachersByNamePattern(widget.searchText);
      teachers = null;
    else
      teachers = widget.loadedClass.students;

    return teachers.isNotEmpty
        ? ListView.builder(
            itemCount: teachers.length,
            itemBuilder: (ctx, i) => SchoolTeacherItem(teachers[i]),
          )
        : Center(
            child: Container(
              child: Text("Please add Teachers"),
            ),
          );
  }
}
