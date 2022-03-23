import 'package:flutter/material.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/providers/cart.dart';
import 'package:vidbusters/providers/orders.dart';
import 'package:vidbusters/providers/pharmacies.dart';
import 'package:vidbusters/providers/product.dart';
import 'package:vidbusters/providers/users.dart';
import 'package:vidbusters/screens/pharmacy/appdrawer/orders_screen.dart';
import 'package:vidbusters/screens/pharmacy_waiting.dart';
import 'package:vidbusters/screens/user/Medicines screen.dart';
import 'package:vidbusters/screens/appdrawer/cart_screen.dart';
import 'package:vidbusters/screens/forms/pharmacy_registration.dart';
import 'package:vidbusters/screens/appdrawer/orders_screen.dart';
import 'package:vidbusters/screens/user/pharmacy_detail_screen.dart';
import 'package:vidbusters/screens/pharmacy/products_overview_screen.dart';
import 'package:vidbusters/screens/starting.dart';
import 'package:vidbusters/screens/forms/login.dart';
import 'package:vidbusters/screens/forms/user_register.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/screens/user/reports.dart';
import 'package:vidbusters/screens/user_waiting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Users user = new Users();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    for (int i=0 ; i<Selected.arr.length;i++){
      Selected.arr[i] = false;
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Product(),
        ),
        ChangeNotifierProvider.value(
          value: Pharmacies(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        routes: {
          '/': (context) => Starting(),
          '/login': (context) => Login(),
          '/userregisterarion': (context) => UserRegistration(),
          '/pharmacyregisteration': (context) => PharmacyRigestraion(),
          '/pharmacy': (context) => ProductsOverviewScreen(),
          '/user': (context) => MedicineScreen(),
          '/userwaiting': (ctx) => Waiting(),
          '/pharmacywaiting': (context) => PharmacyWaiting(),
          PharmacyDetailScreen.routeName: (ctx) => PharmacyDetailScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          pharmacyOrdersScreen.routeName: (ctx) => pharmacyOrdersScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          '/reports': (context) => Reports(),
        },
      ),
    );
  }
}
