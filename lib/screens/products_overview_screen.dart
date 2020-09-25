import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
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
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () async {
      //     final snapshot =
      //         await FirebaseFirestore.instance.collection('videos').get();
      //     snapshot.docs.forEach((doc) => {print(doc.get('title'))});
      //     //   video.
      //     //   .snapshots()
      //     //   .listen((data) {
      //     // data.docs.forEach((element) {
      //     //   print(element.get('title'));
      //     // });
      //   },
      // ),
    );
  }
}
