import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuto/providers/auth.dart';
import 'package:tuto/providers/chapters.dart';
import 'package:tuto/providers/questions.dart';
import 'package:tuto/screens/questions.dart';
import 'package:tuto/screens/edit_chapter.dart';
import 'package:tuto/screens/edit_question.dart';

import './screens/cart_screen.dart';
import 'screens/books_overview.dart';
import 'screens/chapters.dart';
import 'providers/books.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'screens/edit_book.dart';
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
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Books(),
        ),
        ChangeNotifierProvider.value(
          value: Chapters(),
        ),
        ChangeNotifierProvider.value(
          value: Questions(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'workbook',
          theme: ThemeData(
            //primarySwatch: Colors.purple,
            //accentColor: Colors.deepOrange,
            primarySwatch: Colors.indigo,
            accentColor: Colors.amber,
            fontFamily: 'Lato',
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
                          return ProductsOverviewScreen();
                        }
                      });
                  //return ProductsOverviewScreen();
                }
                return AuthScreen();
              }),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            BookDetailScreen.routeName: (ctx) => BookDetailScreen(),
            ChapterDetailScreen.routeName: (ctx) => ChapterDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditBookScreen.routeName: (ctx) => EditBookScreen(),
            EditChapterScreen.routeName: (ctx) => EditChapterScreen(),
            EditQuestionScreen.routeName: (ctx) => EditQuestionScreen(),
          }),
    );
  }
}
