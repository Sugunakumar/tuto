import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    //return   [..._orders];
    return _orders.toList();
  }

  Future<void> fetchAndSetOrders() async {
    final List<OrderItem> loadedOrders = [];
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('orders').get();
      if (snapshot.size == 0) return;

      snapshot.docs.forEach((doc) {
        loadedOrders.add(
          OrderItem(
            id: doc.id,
            amount: doc.get('amount'),
            dateTime: DateTime.parse(doc.get('dateTime')),
            products: (doc.get('products') as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                  ),
                )
                .toList(),
          ),
        );

        print(doc.get('title'));
        print(doc.id);
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final newOrder = {
      'amount': total,
      'dateTime': timeStamp.toIso8601String(),
      'products': cartProducts
          .map((cp) => {
                'id': cp.id,
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
              })
          .toList(),
    };

    final addedOrder =
        await FirebaseFirestore.instance.collection('orders').add(newOrder);
    _orders.insert(
      0,
      OrderItem(
        id: addedOrder.id,
        amount: total,
        dateTime: timeStamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
