import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/constants.dart';
import '../../providers/auth.dart';
import '../edit/edit_book.dart';
import '../../new_providers/books.dart';
import '../../widgets/app_drawer.dart';
import '../../widgets/books_grid.dart';
import '../../widgets/badge.dart';
import '../../providers/cart.dart';
import '../cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

// class ProductsOverviewScreen extends StatefulWidget {
//   static const routeName = '/books';

//   @override
//   _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
// }

// class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
//   var _showOnlyFavorites = false;

//   @override
//   Widget build(BuildContext context) {
//     final authData = Provider.of<Auth>(context, listen: false);
//     final booksData = Provider.of<Books>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Books'),
//         actions: <Widget>[
//           PopupMenuButton(
//             onSelected: (FilterOptions selectedValue) {
//               setState(() {
//                 if (selectedValue == FilterOptions.Favorites) {
//                   _showOnlyFavorites = true;
//                 } else {
//                   _showOnlyFavorites = false;
//                 }
//               });
//             },
//             icon: Icon(
//               Icons.more_vert,
//             ),
//             itemBuilder: (_) => [
//               PopupMenuItem(
//                 child: Text('Only Favorites'),
//                 value: FilterOptions.Favorites,
//               ),
//               PopupMenuItem(
//                 child: Text('Show All'),
//                 value: FilterOptions.All,
//               ),
//             ],
//           ),

//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.of(context).pushNamed(EditBookScreen.routeName);
//             },
//           ),
//           //auth.currentUser.role != Role.Student ?
//           // Consumer<Cart>(
//           //   builder: (_, cart, ch) => Badge(
//           //     child: ch,
//           //     value: cart.itemCount.toString(),
//           //   ),
//           //   child: IconButton(
//           //     icon: Icon(
//           //       Icons.shopping_cart,
//           //     ),
//           //     onPressed: () {
//           //       Navigator.of(context).pushNamed(CartScreen.routeName);
//           //     },
//           //   ),
//           // )
//           //   : Container(),
//           // DropdownButton(
//           //   icon: Icon(
//           //     Icons.more_vert,
//           //     color: Theme.of(context).primaryIconTheme.color,
//           //   ),
//           //   items: [
//           //     DropdownMenuItem(
//           //       child: Container(
//           //         child: Row(
//           //           children: <Widget>[
//           //             Icon(Icons.exit_to_app),
//           //             SizedBox(width: 8),
//           //             Text('Logout')
//           //           ],
//           //         ),
//           //       ),
//           //       value: 'logout',
//           //     )
//           //   ],
//           //   onChanged: (itemIdentifier) {
//           //     if (itemIdentifier == 'logout') {
//           //       FirebaseAuth.instance.signOut();
//           //     }
//           //   },
//           // ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: booksData.books.isNotEmpty
//           ? ProductsGrid(_showOnlyFavorites)
//           : FutureBuilder(
//               future: booksData.fetchAndSetBooks(),
//               builder: (ctx, dataSnapshot) {
//                 if (dataSnapshot.connectionState == ConnectionState.waiting) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else if (dataSnapshot.error != null) {
//                   // Error handling
//                   return Center(child: Text('An Error occured'));
//                 } else {
//                   return ProductsGrid(_showOnlyFavorites);
//                 }
//               }),
//       floatingActionButton: authData.hasAccess(Entity.Book, Operations.Add)
//           ? FloatingActionButton(
//               child: Icon(Icons.add),
//               onPressed: () {
//                 Navigator.of(context).pushNamed(EditBookScreen.routeName);
//               },
//             )
//           : Container(),
//     );
//   }
// }
