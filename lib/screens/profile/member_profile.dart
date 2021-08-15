// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:tuto/new_providers/models.dart';

// import 'package:tuto/new_providers/school.dart';
// import 'package:tuto/new_providers/schools.dart';
// import 'package:tuto/providers/auth.dart';
// import 'package:tuto/widgets/list/teachers_list.dart';

// import '../edit/edit_class.dart';
// import '../edit/edit_school.dart';
// import '../../widgets/list/classes_list.dart';

// School loadedSchool;
// //SchoolsModel schoolsData;
// //ClassModel classModel;
// //SchoolProvider schoolData;
// //Teachers teachersData;
// //Tasks tasksData;
// Auth authProvider;

// class MemberProfile extends StatefulWidget {
//   static const routeName = '/school-profile';

//   @override
//   _MemberProfileState createState() => _MemberProfileState();
// }

// class _MemberProfileState extends State<MemberProfile>
//     with SingleTickerProviderStateMixin {
//   TabController _tabController;

//   @override
//   void initState() {
//     _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
//     _tabController.addListener(_handleTabIndex);
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _tabController.removeListener(_handleTabIndex);
//     _tabController.dispose();
//     super.dispose();
//   }

//   void _handleTabIndex() {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     loadedSchool = context.watch<SchoolNotifier>().school;
//     print("loadedSchool.name : " + loadedSchool.name);

//     //loadedSchool = schoolsData.loadSchoolById(schoolId);
//     //classModel = Provider.of<ClassModel>(context, listen: false);
//     //classModel.fetchAndSetClasses(loadedSchool);
//     //schoolData = Provider.of<SchoolProvider>(context);
//     //loadedSchool = schoolData.schools.findById(schoolId);
//     //schoolData.school = loadedSchool;
//     //loadedSchool = schoolsData.findById(schoolId);

//     ///schoolData.schoolId = schoolId;
//     //teachersData = Provider.of<Teachers>(context);
//     //tasksData = Provider.of<Tasks>(context, listen: false);

//     authProvider = Provider.of<Auth>(context, listen: false);

//     return SafeArea(
//       top: false,
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             bottom: TabBar(
//               controller: _tabController,
//               tabs: [
//                 Tab(child: Text("Classes")),
//                 Tab(child: Text("Teachers")),
//               ],
//             ),
//             title: Text(loadedSchool.name),
//             actions: <Widget>[
//               IconButton(
//                 icon: const Icon(Icons.search),
//                 onPressed: () {
//                   Navigator.of(context).pushNamed(EditSchoolScreen.routeName,
//                       arguments: loadedSchool.id);
//                 },
//               ),
//               // IconButton(
//               //   icon: const Icon(Icons.delete),
//               //   onPressed: () async {
//               //     try {
//               //       await schoolsData.delete(schoolId);
//               //       Navigator.of(context).pop();
//               //       Scaffold.of(context).showSnackBar(
//               //         SnackBar(
//               //           content: Text(
//               //             'School deleted',
//               //             textAlign: TextAlign.center,
//               //           ),
//               //         ),
//               //       );
//               //     } catch (e) {
//               //       Scaffold.of(context).showSnackBar(
//               //         SnackBar(
//               //           content: Text(
//               //             'Deleting Failed',
//               //             textAlign: TextAlign.center,
//               //           ),
//               //         ),
//               //       );
//               //     }
//               //   },
//               //   color: Theme.of(context).errorColor,
//               // ),
//             ],
//           ),

//           //backgroundColor: Colors.grey.shade300,
//           //body: getPage(_currentPage),
//           body: TabBarView(
//             controller: _tabController,
//             children: [
//               //ClassesTab(loadedSchool),
//               TeachersTab(loadedSchool),
//               // TeachersTab(),
//               //TabList(),
//             ],
//           ),
//           //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//           floatingActionButton: _bottomButtons(),
//           // bottomNavigationBar: AnimatedBottomNav(
//           //     currentIndex: _currentPage,
//           //     onChange: (index) {
//           //       setState(() {
//           //         _currentPage = index;
//           //       });
//           //     }),
//         ),
//       ),
//     );
//   }

//   // getPage(int page) {
//   //   switch (page) {
//   //     case 0:
//   //       return ProfileTab();
//   //     case 1:
//   //       return TeachersTab();
//   //     case 2:
//   //       return ClassesTab();
//   //   }
//   // }

//   // Future<void> addTeacherByEmailDialog(BuildContext context) async {
//   //   await showDialog(
//   //       context: context,
//   //       builder: (ctx) {
//   //         return AddDialogWidget();
//   //       });
//   // }

//   Widget _bottomButtons() {
//     if (_tabController.index == 0) {
//       return FloatingActionButton(
//         shape: StadiumBorder(),
//         onPressed: () => {
//           Navigator.of(context).pushNamed(EditClassScreen.routeName),
//         },
//         child: Icon(
//           Icons.add,
//         ),
//       );
//     } else if (_tabController.index == 1) {
//       return FloatingActionButton(
//           shape: StadiumBorder(),
//           onPressed: () async {
//             print('floating action button');
//             //await addTeacherByEmailDialog(context);
//             //Navigator.of(context).pushNamed(EditTeacherScreen.routeName),
//           },
//           child: Icon(
//             Icons.add,
//           ));
//     } else
//       return null;
//   }
// }

// // class AddDialogWidget extends StatefulWidget {
// //   AddDialogWidget({
// //     Key key,
// //   }) : super(key: key);

// //   @override
// //   _AddDialogWidgetState createState() => _AddDialogWidgetState();
// // }

// // class _AddDialogWidgetState extends State<AddDialogWidget> {
// //   final _form = GlobalKey<FormState>();

// //   var _isLoading = false;
// //   var _teacherEmail = '';
// //   var _isAdmin = false;

// //   Future<void> _saveForm() async {
// //     final isValid = _form.currentState.validate();
// //     if (!isValid) {
// //       return;
// //     }
// //     _form.currentState.save();
// //     setState(() {
// //       _isLoading = true;
// //     });

// //     try {
// //       print("_teacherEmail : " +
// //           _teacherEmail +
// //           '  isAdmin : ' +
// //           _isAdmin.toString());

// //       CurrentUser addedUser =
// //           await authProvider.fetchUserByEmail(_teacherEmail);
// //       await schoolData.addTeacher(addedUser);
// //       //await loadedSchool.addTeacher(addedUser);
// //     } catch (e) {
// //       await showDialog<Null>(
// //           context: context,
// //           builder: (ctx) => AlertDialog(
// //                 title: Text('An error occured!'),
// //                 content: Text('Something went wrong'),
// //                 actions: [
// //                   FlatButton(
// //                     child: Text('Okay'),
// //                     onPressed: () {
// //                       Navigator.of(context).pop();
// //                     },
// //                   )
// //                 ],
// //               ));
// //     }
// //     //  finally {
// //     //   setState(() {
// //     //     _isLoading = false;
// //     //   });
// //     //   Navigator.of(context).pop();
// //     // }

// //     setState(() {
// //       _isLoading = false;
// //     });
// //     Navigator.of(context).pop();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return _isLoading
// //         ? Center(
// //             child: CircularProgressIndicator(),
// //           )
// //         : AlertDialog(
// //             title: Text('Add Teacher'),
// //             content: Form(
// //               key: _form,
// //               child: Column(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   TextFormField(
// //                     autocorrect: false,
// //                     decoration: InputDecoration(labelText: 'Email'),
// //                     keyboardType: TextInputType.emailAddress,
// //                     textInputAction: TextInputAction.done,
// //                     onFieldSubmitted: (_) {
// //                       _saveForm();
// //                     },
// //                     validator: (value) {
// //                       if (value.trim().isEmpty || !value.contains('@')) {
// //                         return 'Please enter a valid email address.';
// //                       }
// //                       return null;
// //                     },
// //                     onSaved: (value) {
// //                       _teacherEmail = value;
// //                     },
// //                   ),
// //                   // Row(
// //                   //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   //   children: [
// //                   //     Text("Is Admin ?"),
// //                   //     Checkbox(
// //                   //         value: _isAdmin,
// //                   //         onChanged: (checked) {
// //                   //           setState(() {
// //                   //             _isAdmin = checked;
// //                   //           });
// //                   //         })
// //                   //   ],
// //                   // )
// //                 ],
// //               ),
// //             ),
// //             actions: [
// //               FlatButton(
// //                 child: Text('Cancel'),
// //                 onPressed: () {
// //                   Navigator.of(context).pop();
// //                 },
// //               ),
// //               FlatButton(
// //                 child: Text('Add'),
// //                 onPressed: () {
// //                   _saveForm();
// //                 },
// //               )
// //             ],
// //           );
// //   }
// // }

// // class TeachersTab extends StatelessWidget {
// //   const TeachersTab({Key key}) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     Future<void> _refresh(BuildContext context) async {
// //       await schoolData.fetchAndSetTeachers();
// //     }

// //     return RefreshIndicator(
// //       onRefresh: () => _refresh(context),
// //       child: schoolData.teachers.isEmpty
// //           ? FutureBuilder(
// //               future: _refresh(context),
// //               builder: (ctx, dataSnapshot) {
// //                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
// //                   return Center(
// //                     child: CircularProgressIndicator(),
// //                   );
// //                 } else if (dataSnapshot.error != null) {
// //                   // Error handling
// //                   print(dataSnapshot.error.toString());
// //                   return Center(child: Text('An Error occured'));
// //                 } else {
// //                   return TeachersList();
// //                 }
// //               })
// //           : TeachersList(),
// //     );
// //   }
// // }

// class AnimatedBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onChange;
//   const AnimatedBottomNav({Key key, this.currentIndex, this.onChange})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: kToolbarHeight,
//       decoration: BoxDecoration(color: Colors.white),
//       child: Row(
//         children: <Widget>[
//           // Expanded(
//           //   child: InkWell(
//           //     onTap: () => onChange(0),
//           //     child: BottomNavItem(
//           //       icon: Icons.home,
//           //       title: "Profile",
//           //       isActive: currentIndex == 0,
//           //     ),
//           //   ),
//           // ),
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange(1),
//               child: BottomNavItem(
//                 icon: Icons.group,
//                 title: "Teachers",
//                 isActive: currentIndex == 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange(2),
//               child: BottomNavItem(
//                 icon: Icons.book,
//                 title: "Classes",
//                 isActive: currentIndex == 2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomNavItem extends StatelessWidget {
//   final bool isActive;
//   final IconData icon;
//   final Color activeColor;
//   final Color inactiveColor;
//   final String title;
//   const BottomNavItem(
//       {Key key,
//       this.isActive = false,
//       this.icon,
//       this.activeColor,
//       this.inactiveColor,
//       this.title})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//         transitionBuilder: (child, animation) {
//           return SlideTransition(
//             position: Tween<Offset>(
//               begin: const Offset(0.0, 1.0),
//               end: Offset.zero,
//             ).animate(animation),
//             child: child,
//           );
//         },
//         duration: Duration(milliseconds: 500),
//         reverseDuration: Duration(milliseconds: 200),
//         child: isActive
//             ? Container(
//                 color: Colors.white,
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Wrap(
//                       crossAxisAlignment: WrapCrossAlignment.center,
//                       children: [
//                         Icon(
//                           icon,
//                           color: activeColor ?? Theme.of(context).primaryColor,
//                         ),
//                         Text(
//                           ' ' + title,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color:
//                                 activeColor ?? Theme.of(context).primaryColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 5.0),
//                     Container(
//                       width: 5.0,
//                       height: 5.0,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: activeColor ?? Theme.of(context).primaryColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : Wrap(
//                 crossAxisAlignment: WrapCrossAlignment.center,
//                 children: [
//                   Icon(
//                     icon,
//                     color: inactiveColor ?? Colors.grey,
//                   ),
//                   Text(' ' + title,
//                       style: TextStyle(color: inactiveColor ?? Colors.grey)),
//                 ],
//               ));
//   }
// }
