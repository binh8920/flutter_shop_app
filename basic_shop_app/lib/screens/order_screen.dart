import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart' show OrderProvider;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Order'),
      ),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (context, index) => OrderItem(orderData.orders[index]),
      ),
      drawer: AppDrawer(),
    );
  }
}
