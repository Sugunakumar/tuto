import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../new_providers/books.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import 'edit/edit_book.dart';

// class UserProductsScreen extends StatelessWidget {
//   static const routeName = '/user-products';

//   Future<void> _refreshProducts(BuildContext context) async {
//     //await Provider.of<Books>(context).fetchAndSetProducts();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final productsData = Provider.of<Books>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Manage Books'),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.of(context).pushNamed(EditBookScreen.routeName);
//             },
//           ),
//         ],
//       ),
//       drawer: AppDrawer(),
//       body: RefreshIndicator(
//         onRefresh: () => _refreshProducts(context),
//         child: Padding(
//           padding: EdgeInsets.all(8),
//           child: ListView.builder(
//             itemCount: productsData.books.length,
//             itemBuilder: (_, i) => Column(
//               children: [
//                 UserBookItem(
//                   productsData.books[i].id,
//                   productsData.books[i].title,
//                   productsData.books[i].imageUrl,
//                 ),
//                 Divider(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
