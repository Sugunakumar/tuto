// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tuto/models/class.dart';
// import 'package:tuto/providers/schoolProvider.dart';
// import 'package:tuto/providers/schoolModel.dart';
// import 'package:tuto/screens/profile/class_profile.dart';

// import '../../providers/chapters.dart';
// import '../edit/edit_chapter.dart';

// // SchoolProvider classesData;

// // class ClassesOverviewScreen extends StatefulWidget {
// //   static const routeName = '/classes-overview';

// //   @override
// //   _ClassesOverviewScreenState createState() => _ClassesOverviewScreenState();
// // }

// // class _ClassesOverviewScreenState extends State<ClassesOverviewScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     final schoolId =
// //         ModalRoute.of(context).settings.arguments as String; // is the id!
// //     //classes = school.classes;
// //     //print("classes : " + classes.toString());
// //     final schoolData = Provider.of<SchoolsModel>(context, listen: false);
// //     classesData = Provider.of<SchoolProvider>(context, listen: false);

// //     final loadedSchool = schoolData.findById(schoolId);
// //     classesData.school = loadedSchool;
// //     return Scaffold(
// //         appBar: AppBar(
// //           title: Text('Classes'),
// //           actions: <Widget>[
// //             IconButton(
// //               icon: const Icon(Icons.add),
// //               onPressed: () {
// //                 Navigator.of(context).pushNamed(EditChapterScreen.routeName);
// //               },
// //             ),
// //           ],
// //         ),
// //         body: classesData.classes.isEmpty
// //             ? FutureBuilder(
// //                 future: classesData.fetchAndSetClasses(),
// //                 builder: (ctx, dataSnapshot) {
// //                   if (dataSnapshot.connectionState == ConnectionState.waiting) {
// //                     return Center(
// //                       child: CircularProgressIndicator(),
// //                     );
// //                   } else if (dataSnapshot.error != null) {
// //                     // Error handling
// //                     print(dataSnapshot.error.toString());
// //                     return Center(child: Text('An Error occured'));
// //                   } else {
// //                     return ClassesList();
// //                   }
// //                 })
// //             : ClassesList(),
// //         floatingActionButton: FloatingActionButton(
// //           child: Icon(Icons.add),
// //           onPressed: () =>
// //               Navigator.of(context).pushNamed(EditChapterScreen.routeName),
// //         )
// //         //: Container(),
// //         );
// //   }
// // }

// // class ClassesList extends StatelessWidget {
// //   ClassesList();

// //   @override
// //   Widget build(BuildContext context) {
// //     return ListView.builder(
// //       itemCount: classesData.classes.length,
// //       itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
// //         value: classesData.classes[i],
// //         child: ClassItem(),
// //       ),
// //     );
// //   }
// // }

// // class ClassItem extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final scaffold = Scaffold.of(context);
// //     return ClipRRect(
// //       borderRadius: BorderRadius.circular(10),
// //       child: Consumer<Class>(
// //         builder: (ctx, clazz, _) => ListTile(
// //           leading: Text('clazz.teacherId'),
// //           title: Center(child: Text(clazz.name)),
// //           subtitle: Center(child: Text(clazz.grade)),
// //           trailing: Container(
// //             width: 100,
// //             child: Row(
// //               children: <Widget>[
// //                 IconButton(
// //                   icon: Icon(Icons.edit),
// //                   onPressed: () {
// //                     Navigator.of(context).pushNamed(EditChapterScreen.routeName,
// //                         arguments: clazz.id);
// //                   },
// //                   color: Theme.of(context).primaryColor,
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.delete),
// //                   onPressed: () async {
// //                     try {
// //                       await Provider.of<Chapters>(context, listen: false)
// //                           .deleteChapter(clazz.id);
// //                     } catch (e) {
// //                       scaffold.showSnackBar(
// //                         SnackBar(
// //                           content: Text(
// //                             'Deleting Failed',
// //                             textAlign: TextAlign.center,
// //                           ),
// //                         ),
// //                       );
// //                     }
// //                   },
// //                   color: Theme.of(context).errorColor,
// //                 ),
// //               ],
// //             ),
// //           ),
// //           onTap: () {
// //             Navigator.of(context)
// //                 .pushNamed(ClassProfile.routeName, arguments: clazz.id);
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }
