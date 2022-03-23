import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/orders.dart';
import 'package:vidbusters/widgets/appdrawer/appdrawer.dart';
import 'package:vidbusters/widgets/appdrawer/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  @override
  _OrdersScreen createState() =>
      _OrdersScreen();
}
class _OrdersScreen extends State<OrdersScreen>{
  var _isInit = true;
  var _isLoading = false;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
       Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
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
    print('building orders');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body:
          _isLoading ?
                  Center(child: CircularProgressIndicator())

          : Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => Order_item(orderData.orders[i]),
                ),
              ),
    );
  }
}
