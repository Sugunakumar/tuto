import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuto/models/school.dart';
import 'package:tuto/providers/classes.dart';
import 'package:tuto/providers/schools.dart';
import 'package:tuto/providers/students.dart';
import 'package:tuto/providers/tasks.dart';
import 'package:tuto/providers/teachers.dart';
import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/screens/edit/edit_teacher.dart';
import 'package:tuto/screens/overview/classes_overview.dart';
import 'package:tuto/screens/overview/schools_overview.dart';
import 'package:tuto/screens/overview/home_page.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';
import 'package:tuto/screens/trails_screen.dart';
import './providers/auth.dart';
import './providers/chapters.dart';
import './providers/questions.dart';
import 'screens/overview/chapter_questions.dart';
import 'screens/edit/edit_chapter.dart';
import 'screens/edit/edit_question.dart';

import './screens/cart_screen.dart';
import 'screens/overview/books_overview.dart';
import 'screens/overview/book_chapters.dart';
import './providers/books.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/edit/edit_book.dart';
import './screens/auth_screen.dart';
import './screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Schools()),
        ChangeNotifierProvider.value(value: Classes()),
        // ChangeNotifierProxyProvider<Schools, Classes>(
        //     update: (ctx, school, previousClasses) => Classes(school.)),
        ChangeNotifierProvider.value(value: Teachers()),
        ChangeNotifierProvider.value(value: Students()),
        ChangeNotifierProvider.value(value: Tasks()),
        ChangeNotifierProvider.value(value: Books()),
        ChangeNotifierProvider.value(value: Chapters()),
        ChangeNotifierProvider.value(value: Questions()),
        // ChangeNotifierProvider.value(
        //   value: Cart(),
        // ),
        // ChangeNotifierProvider.value(
        //   value: Orders(),
        // ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'workbook',
          theme: ThemeData(
            //primarySwatch: Colors.purple,
            //accentColor: Colors.deepOrange,
            primarySwatch: Colors.indigo,
            //accentColor: Colors.indigoAccent,
            //fontFamily: 'Lato',
          ),
          home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen();
                }
                if (userSnapshot.hasData) {
                  return FutureBuilder(
                      future: Provider.of<Auth>(ctx, listen: false)
                          .fetchCurrentUser(),
                      builder: (ctx, dataSnapshot) {
                        if (dataSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (dataSnapshot.error != null) {
                          // Error handling
                          return Center(child: Text('An Error occured'));
                        } else {
                          //return ProductsOverviewScreen();
                          //return MyHomePage();
                          //return profilePage();
                          return HomeScreen();
                        }
                      });
                  //return ProductsOverviewScreen();
                }
                return AuthScreen();
              }),
          routes: {
            SchoolOverviewScreen.routeName: (ctx) => SchoolOverviewScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            BookDetailScreen.routeName: (ctx) => BookDetailScreen(),
            ChapterDetailScreen.routeName: (ctx) => ChapterDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            // Profile
            SchoolProfile.routeName: (ctc) => SchoolProfile(),
            ClassProfile.routeName: (ctc) => ClassProfile(),

            // Overview
            ClassesOverviewScreen.routeName: (ctc) => ClassesOverviewScreen(),

            // Edit Screen
            EditBookScreen.routeName: (ctx) => EditBookScreen(),
            EditChapterScreen.routeName: (ctx) => EditChapterScreen(),
            EditQuestionScreen.routeName: (ctx) => EditQuestionScreen(),
            EditSchoolScreen.routeName: (ctx) => EditSchoolScreen(),
            EditTeacherScreen.routeName: (ctx) => EditTeacherScreen(),
            EditClassScreen.routeName: (ctx) => EditClassScreen(),
          }),
    );
  }
}
