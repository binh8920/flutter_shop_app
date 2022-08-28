import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _item = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

//manage state this way can affect app-wide state where we don't want to update
//instead, we cam use stateful widget in products_overview_screen
  // var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Product findById(String id) {
    return _item.firstWhere((element) => element.id == id);
  }

  List<Product> get items {
    // if (_showFavoritesOnly) {
    //   return _item.where((element) => element.isFavorite).toList();
    // } else {
    return [..._item];
    //}
  }

  List<Product> get favoritesItem {
    return _item.where((element) => element.isFavorite).toList();
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        'https://flutter-shop-6c05c-default-rtdb.firebaseio.com/products.json');
    return http
        .post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    )
        .then((value) {
      print(value.body);
      final newProduct = Product(
          id: json.decode(value.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _item.add(newProduct);
      //_item.insert(0, newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  void updateProduct(String productId, Product newProduct) {
    final productIndex = _item.indexWhere((element) => element.id == productId);
    if (productIndex >= 0) {
      _item[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _item.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
