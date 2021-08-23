import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schoolStudent.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/widgets/item/schoolStudent_item.dart';

class SchoolStudentsTab extends StatelessWidget {
  final School loadedSchool;
  final bool isSearching;
  final String searchText;

  SchoolStudentsTab(this.loadedSchool, this.isSearching, this.searchText,
      {Key key})
      : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    final auth = Provider.of<Auth>(context, listen: false);
    await this.loadedSchool.fetchAndSetStudents(auth);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _refreshProducts(context),
      child: loadedSchool.students.isEmpty
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
                  return StudentsList(loadedSchool, isSearching, searchText);
                }
              })
          : StudentsList(loadedSchool, isSearching, searchText),
    );
  }
}

class StudentsList extends StatefulWidget {
  final School loadedSchool;
  final bool isSearching;
  final String searchText;

  const StudentsList(this.loadedSchool, this.isSearching, this.searchText,
      {Key key})
      : super(key: key);

  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {
  @override
  Widget build(BuildContext context) {
    List<SchoolStudent> students;
    if (widget.isSearching)
      students =
          widget.loadedSchool.findStudentByNamePattern(widget.searchText);
    else
      students = widget.loadedSchool.students;

    return students.isNotEmpty
        ? ListView.builder(
            itemCount: students.length,
            itemBuilder: (ctx, i) => SchoolStudentItem(students[i]),
          )
        : Center(
            child: Container(
              child: Text("Please add Students"),
            ),
          );
  }
}
