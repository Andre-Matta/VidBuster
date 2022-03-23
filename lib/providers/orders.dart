import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:vidbusters/providers/Selected.dart';
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  final String pharmacyEmail;
  final String userEmail;
  final String phone;
  final String area;
  final String street;
  final String building;
  final String floor;
  double lat, lng;
  OrderItem(
      {this.id,
      this.amount,
      this.products,
      this.dateTime,
      this.pharmacyEmail,
      this.userEmail,
      this.phone,
      this.area,
      this.street,
      this.building,
      this.floor,
      this.lat,
      this.lng});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      if (orderData['userEmail'] == Selected.userEmail) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title'],
                  ),
                )
                .toList(),
          ),
        );
      }
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(
      List<CartItem> cartProducts,
      double total,
      String UserEmail,
      String phone,
      String area,
      String street,
      String building,
      String floor,
      double lat,
      double lng) async {
    const url =
        'https://pharmacies-f20f5-default-rtdb.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'phone': phone,
        'area': area,
        'street': street,
        'building': building,
        'floor': floor,
        'lat': lat,
        'lng': lng,
        'dateTime': timestamp.toIso8601String(),
        'userEmail': UserEmail,
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                  'pharmacyId': cp.pharmacy
                })
            .toList(),
      }),
    );
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      ),
    );
    notifyListeners();
  }
}
