import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './../models/book.dart';
import '../data/constants.dart';
import '../common/utils.dart';

class Books with ChangeNotifier {
  final productTable = tables['books'];
  final chapterTable = tables['chapters'];

  final db = FirebaseFirestore.instance;

  List<Book> _items = [];

// imageUrl: 'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  List<Book> get items {
    return _items.toList();
  }

  List<Book> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Book findBookById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProducts(String userId) async {
    final List<Book> loadedProducts = [];
    try {
      final snapshot = await db.collection(productTable).get();
      if (snapshot.size == 0) return;
      final userFavSnapshot = await db.collection(userTable).doc(userId).get();

      List<dynamic> fav = userFavSnapshot.data().containsKey('favorites')
          ? userFavSnapshot.get('favorites')
          : null;

      print("fetchAndSetProducts");
      //print("fav : " + fav.toString());

      snapshot.docs.forEach((doc) async {
        loadedProducts.add(
          Book(
            id: doc.id,
            grade: doc.get('grade'),
            subject: doc.get('subject'),
            title: doc.get('title'),
            description: doc.get('description'),
            pages: doc.get('pages'),
            editor: doc.get('editor'),
            publisher: doc.get('publisher'),
            imageUrl: doc.get('imageUrl'),
            isFavorite:
                fav == null ? false : fav.contains(doc.id) ? true : false,
          ),
        );

        //print(doc.id);
      });

      // final snapshotQ =
      //     await FirebaseFirestore.instance.collectionGroup("questions").get();
      // snapshotQ.docs.forEach((element) {
      //   print("questions : " + element.get("answer"));
      // });

      // final snapshotChap =
      //     await FirebaseFirestore.instance.collectionGroup("chapters").get();
      // snapshotChap.docs.forEach((element) {
      //   print("chapters : " + element.get("title"));
      // });

      // final snapshottrial = await FirebaseFirestore.instance
      //     .collection(productTable)
      //     .doc("1Lf87x0AKGdW4CDnzkHc")
      //     .collection("chapters")
      //     .get();
      // snapshottrial.docs.forEach((element) {
      //   print("plain way : " + element.get("title"));
      // });

      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Book product) async {
    final newProduct = {
      'grade': product.grade,
      'subject': product.subject.capitalizeFirstofEach,
      'title': product.title.capitalizeFirstofEach,
      'description': product.description,
      'pages': product.pages,
      'editor': product.editor.inCaps,
      'publisher': product.publisher.capitalizeFirstofEach,
      'imageUrl': product.imageUrl
    };

    try {
      final addedProduct = await FirebaseFirestore.instance
          .collection(productTable)
          .add(newProduct);
      final newProductList = Book(
        id: addedProduct.id,
        grade: product.grade,
        subject: product.subject.capitalizeFirstofEach,
        title: product.title.capitalizeFirstofEach,
        description: product.description,
        pages: product.pages,
        editor: product.editor.inCaps,
        publisher: product.publisher.capitalizeFirstofEach,
        imageUrl: product.imageUrl,
      );
      //_items.add(newProductList);
      _items.insert(0, newProductList);
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> updateProduct(String id, Book newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      try {
        await FirebaseFirestore.instance
            .collection(productTable)
            .doc(id)
            .update({
          'grade': newProduct.grade,
          'subject': newProduct.subject,
          'title': newProduct.title,
          'description': newProduct.description,
          'pages': newProduct.pages,
          'editor': newProduct.editor,
          'publisher': newProduct.publisher,
          'imageUrl': newProduct.imageUrl
        });
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection(productTable)
          .doc(id)
          .delete();
      existingProduct = null;
    } catch (e) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw e;
    }
  }
}
