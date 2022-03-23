import 'package:flutter/material.dart';
import 'package:vidbusters/screens/pharmacy/appdrawer/orders_screen.dart';


class pahrmacyAppDrawer extends StatelessWidget {
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
              Navigator.of(context).pushReplacementNamed('/pharmacy');
            },
          ),

          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(pharmacyOrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
