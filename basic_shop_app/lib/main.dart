import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/products_detail_screen.dart';
import './providers/product_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProductProvider(),
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            fontFamily: 'Lato',
            accentColor: Colors.orangeAccent),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen()
        },
      ),
    );
  }
}
