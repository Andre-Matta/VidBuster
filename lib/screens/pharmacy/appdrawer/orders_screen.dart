import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/providers/cart.dart';
import 'package:vidbusters/providers/orders.dart';
import 'package:vidbusters/widgets/pharmacy/pharmacyAppdrawer/PharmacyAppdrawer.dart';
import 'package:vidbusters/widgets/pharmacy/pharmacyAppdrawer/pharmacyOrder_item.dart';
import 'package:http/http.dart' as http;

final List<OrderItem> loadedOrders = [];
final List<OrderItem> fulterdloadedOrders = [];

class pharmacyOrdersScreen extends StatefulWidget {
  static const routeName = '/pharmacyorders';
  @override
  _OrdersScreen createState() => _OrdersScreen();
}

class _OrdersScreen extends State<pharmacyOrdersScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadedOrders.clear();
      setState(() {
        _isLoading = true;
      });
      fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  Future<bool> onWillPop() {
    Widget okButton = FlatButton(
        child: Text("OK"),
        onPressed: () {
          exit(0);
        });
    Widget cancelButton = FlatButton(
        child: Text("cancel"),
        onPressed: () {
          Navigator.of(context).pop();
        });
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(15)),
            title: Text("Exit"),
            content: Text("Are you sure you want to exit?"),
            actions: [okButton, cancelButton],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < loadedOrders.length; i++) {
      for (int j = 0; j < loadedOrders[i].products.length; j++) {
        if (loadedOrders[i].products[j].pharmacy != Selected.userEmail) {
          loadedOrders[i].products.removeAt(j);
        }
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: pahrmacyAppDrawer(),
        body: _isLoading
            ? WillPopScope(
                child: Center(child: CircularProgressIndicator()),
                onWillPop: onWillPop)
            : WillPopScope(
                child: ListView.builder(
                  itemCount: loadedOrders.length,
                  itemBuilder: (ctx, i) => pharmacyOrder_item(loadedOrders[i]),
                ),
                onWillPop: onWillPop));
  }
}

Future<void> fetchAndSetOrders() async {
  const url =
      'https://pharmacies-f20f5-default-rtdb.firebaseio.com/orders.json';
  bool f = false;
  final response = await http.get(url);
  final extractedData = json.decode(response.body) as Map<String, dynamic>;
  if (extractedData == null) {
    return;
  }

  extractedData.forEach((orderId, orderData) {
    final a = orderData['products'] as List<dynamic>;
    a.forEach((itemm) {
      if (itemm['pharmacyId'] == Selected.userEmail) {
        f = true;
      }
    });
    if (f) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          phone: orderData['phone'],
          area: orderData['area'],
          street: orderData['street'],
          building: orderData['building'],
          floor: orderData['floor'],
          lat: orderData['lat'],
          lng: orderData['lng'],
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                  pharmacy: item['pharmacyId'],
                ),
              )
              .toList(),
        ),
      );
    }
    f = false;
  });
}
