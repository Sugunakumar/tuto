import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/constants.dart';
import '../providers/auth.dart';
import '../screens/edit_book.dart';
import '../providers/books.dart';
import '../widgets/app_drawer.dart';
import '../widgets/books_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import 'cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),

          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditBookScreen.routeName);
            },
          ),
          //auth.currentUser.role != Role.Student ?
          // Consumer<Cart>(
          //   builder: (_, cart, ch) => Badge(
          //     child: ch,
          //     value: cart.itemCount.toString(),
          //   ),
          //   child: IconButton(
          //     icon: Icon(
          //       Icons.shopping_cart,
          //     ),
          //     onPressed: () {
          //       Navigator.of(context).pushNamed(CartScreen.routeName);
          //     },
          //   ),
          // )
          //   : Container(),
          // DropdownButton(
          //   icon: Icon(
          //     Icons.more_vert,
          //     color: Theme.of(context).primaryIconTheme.color,
          //   ),
          //   items: [
          //     DropdownMenuItem(
          //       child: Container(
          //         child: Row(
          //           children: <Widget>[
          //             Icon(Icons.exit_to_app),
          //             SizedBox(width: 8),
          //             Text('Logout')
          //           ],
          //         ),
          //       ),
          //       value: 'logout',
          //     )
          //   ],
          //   onChanged: (itemIdentifier) {
          //     if (itemIdentifier == 'logout') {
          //       FirebaseAuth.instance.signOut();
          //     }
          //   },
          // ),
        ],
      ),
      drawer: AppDrawer(),
      body:
          //_isLoading
          //     ? Center(
          //         child: CircularProgressIndicator(),
          //       )
          //   :
          FutureBuilder(
              future: Provider.of<Books>(context, listen: false)
                  .fetchAndSetProducts(authData.currentUser.id),
              builder: (ctx, dataSnapshot) {
                if (dataSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (dataSnapshot.error != null) {
                  // Error handling
                  return Center(child: Text('An Error occured'));
                } else {
                  return ProductsGrid(_showOnlyFavorites);
                }
              }),
      floatingActionButton: authData.hasAccess(Entity.Book, Operations.Add)
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditBookScreen.routeName);
              },
              //  () async {
              //   final snapshot =
              //       await FirebaseFirestore.instance.collection('videos').get();
              //   snapshot.docs.forEach((doc) => {print(doc.get('title'))});
              //   video.
              //   .snapshots()
              //   .listen((data) {
              // data.docs.forEach((element) {
              //   print(element.get('title'));
              // }
              //    )
              // },
            )
          : Container(),
    );
  }
}
