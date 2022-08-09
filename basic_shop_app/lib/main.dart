import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';
import 'screens/products_detatail_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Shop',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          fontFamily: 'Lato',
          accentColor: Colors.orangeAccent),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName: (context) => ProductDetailScreen()
      },
    );
  }
}
