import 'package:flutter/material.dart';
import 'package:vidbusters/screens/appdrawer/cart_screen.dart';
import 'package:vidbusters/screens/appdrawer/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.medical_services),
            title: Text('Medicines'),
            onTap: () {
              Navigator.of(context).pushNamed('/user');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart items'),
            onTap: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.report),
            title: Text('Reports'),
            onTap: () {
            Navigator.pushNamed(context, '/reports');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pushNamed('/login');
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
