import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuto/new_providers/book.dart';
import 'package:tuto/new_providers/books.dart';
import 'package:tuto/new_providers/chapter.dart';
import 'package:tuto/new_providers/class.dart';
import 'package:tuto/new_providers/school.dart';
import 'package:tuto/new_providers/schools.dart';
import 'package:tuto/new_providers/teachers.dart';
import 'package:tuto/screens/edit/edit_class.dart';
import 'package:tuto/screens/edit/edit_school.dart';
import 'package:tuto/screens/edit/edit_teacher.dart';
import 'package:tuto/screens/overview/schools_overview.dart';
import 'package:tuto/screens/overview/home_page.dart';
import 'package:tuto/screens/profile/class_profile.dart';
import 'package:tuto/screens/profile/school_profile.dart';
import 'package:tuto/widgets/search_list.dart';
import 'providers/auth.dart';
import 'screens/profile/chapter_profile.dart';
import 'screens/edit/edit_chapter.dart';
import 'screens/edit/edit_question.dart';
import 'screens/cart_screen.dart';
import 'screens/overview/books_overview.dart';
import 'screens/profile/book_profile.dart';
import 'screens/orders_screen.dart';
import 'screens/user_products_screen.dart';
import 'screens/edit/edit_book.dart';
import 'screens/auth_screen.dart';
import 'screens/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Provider.debugCheckInvalidValueType = null;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        //ChangeNotifierProvider.value(value: Schools()),

        // list of schools
        //Provider(create: (context) => Schools()..fetchAndSet()),
        ChangeNotifierProvider(create: (context) => Schools()),
        //Provider(create: (context) => Books()),
        //Provider(create: (context) => ClassNotifier()),
        ChangeNotifierProvider(create: (context) => SchoolNotifier()),
        ChangeNotifierProxyProvider<SchoolNotifier, ClassNotifier>(
          create: (context) => ClassNotifier(),
          update: (ctx, school, previousClass) {
            previousClass.school = school.school;
            return previousClass;
          },
        ),
        ChangeNotifierProxyProvider<SchoolNotifier, Teachers>(
          create: (context) => Teachers(),
          update: (ctx, school, previousTeacher) {
            previousTeacher.school = school.school;
            return previousTeacher;
          },
        ),
        ChangeNotifierProxyProvider<ClassNotifier, BookNotifier>(
          create: (context) => BookNotifier(),
          update: (ctx, classNoti, bookNoti) {
            bookNoti.school = classNoti.school;
            bookNoti.clazz = classNoti.clazz;
            return bookNoti;
          },
        ),
        ChangeNotifierProxyProvider<BookNotifier, ChapterNotifier>(
          create: (context) => ChapterNotifier(),
          update: (ctx, bookNoti, chapterNoti) {
            chapterNoti.school = bookNoti.school;
            chapterNoti.clazz = bookNoti.clazz;
            chapterNoti.book = bookNoti.book;
            return chapterNoti;
          },
        ),
        //ChangeNotifierProvider(create: (context) => BookNotifier()),

        //Provider(create: (context) => School()),

        // ChangeNotifierProxyProvider<Schools, SchoolNotifier>(
        //   create: null,
        //   update: (context, schools, previousSchoolNotifier) {
        //     previousSchoolNotifier.schools = schools;
        //     return previousSchoolNotifier;
        //   },
        // ),

        // Provider(create: (context) => SchoolsModel()),
        // Provider(create: (context) => ClassModel()),

        // ChangeNotifierProxyProvider<SchoolsModel, ClassModel>(
        //   //create: (context) => ClassModel(),
        //   create: null,
        //   update: (context, school, clazz) {
        //     clazz.school = school.loaddedSchool;
        //     return clazz;
        //   },
        // ),

        // ChangeNotifierProxyProvider<ClassModel, BookModel>(
        //   create: (context) => BookModel(),
        //   update: (context, clazz, book) {
        //     book.school = clazz.school;
        //     return book;
        //   },
        // ),
        // school details
        // ChangeNotifierProvider.value(value: SchoolProvider()),

        // ChangeNotifierProxyProvider<SchoolProvider, ClassProvider>(
        //   create: (context) => ClassProvider(),
        //   update: (context, schoolModel, classModel) {
        //     classModel.schoolProvider = schoolModel;
        //     return classModel;
        //   },
        // ),

        // ChangeNotifierProxyProvider<Schools, Classes>(
        //     update: (ctx, school, previousClasses) => Classes(school.)),
        //ChangeNotifierProvider.value(value: Teachers()),
        //ChangeNotifierProvider.value(value: Students()),
        //ChangeNotifierProvider.value(value: Tasks()),
        //ChangeNotifierProvider.value(value: Books()),
        //ChangeNotifierProvider.value(value: Chapters()),
        //ChangeNotifierProvider.value(value: Questions()),
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
                  final authData = Provider.of<Auth>(ctx, listen: false);

                  return authData.currentMember == null
                      ? FutureBuilder(
                          future: Provider.of<Auth>(ctx, listen: false)
                              .fetchCurrentMemeber(),
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
                              //return MyHomePage();
                              return HomeScreen();
                            }
                          })
                      : HomeScreen();
                }
                return AuthScreen();
              }),
          routes: {
            SchoolOverviewScreen.routeName: (ctx) => SchoolOverviewScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            //ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            BookProfile.routeName: (ctx) => BookProfile(),
            ChapterProfile.routeName: (ctx) => ChapterProfile(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            //UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            // Profile
            SchoolProfile.routeName: (ctc) => SchoolProfile(),
            ClassProfile.routeName: (ctc) => ClassProfile(),

            // Overview
            //ClassesOverviewScreen.routeName: (ctc) => ClassesOverviewScreen(),

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
