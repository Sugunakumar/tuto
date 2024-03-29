import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolTeacher.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/widgets/item/schoolTeacher_item.dart';

class TeachersTab extends StatelessWidget {
  final School loadedSchool;
  final bool isSearching;
  final String searchText;

  TeachersTab(this.loadedSchool, this.isSearching, this.searchText, {Key key})
      : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    // fetch and set Members
    final auth = Provider.of<Auth>(context, listen: false);
    //await auth.fetchAndSetMembers();
    // fetch and set School Teachers
    await this.loadedSchool.fetchAndSetTeachers(auth);
    print("refresh called");
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: loadedSchool.teachers.isEmpty
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
                  return TeachersList(loadedSchool, isSearching, searchText);
                }
              })
          : TeachersList(loadedSchool, isSearching, searchText),
    );
  }
}

class TeachersList extends StatefulWidget {
  final School loadedSchool;
  final bool isSearching;
  final String searchText;

  const TeachersList(this.loadedSchool, this.isSearching, this.searchText,
      {Key key})
      : super(key: key);

  @override
  _TeachersListState createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  @override
  Widget build(BuildContext context) {
    List<SchoolTeacher> teachers;
    if (widget.isSearching)
      teachers =
          widget.loadedSchool.findTeachersByNamePattern(widget.searchText);
    else
      teachers = widget.loadedSchool.teachers;

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
