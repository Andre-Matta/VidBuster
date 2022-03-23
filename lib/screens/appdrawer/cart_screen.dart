
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/screens/appdrawer/OrdersLocation.dart';
import 'package:vidbusters/widgets/appdrawer/appdrawer.dart';
import 'package:vidbusters/widgets/appdrawer/cart_item.dart';
import 'package:vidbusters/providers/cart.dart';


class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  @override
  _CartScreen createState() => _CartScreen();
}

  class _CartScreen extends State<CartScreen> {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
        drawer: AppDrawer(),
      body:
        Column(
         children: <Widget>[
           Card(
             margin: EdgeInsets.all(15),
             child: Padding(
               padding: EdgeInsets.all(8),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: <Widget>[
                   Text(
                     'Total',
                     style: TextStyle(fontSize: 20),
                   ),
                   Spacer(),
                   Chip(
                     label: Text(
                       '${cart.totalAmount.toStringAsFixed(2)} L.E',
                       style: TextStyle(
                         color: Theme.of(context).primaryTextTheme.title.color,
                       ),
                     ),
                     backgroundColor: Theme.of(context).primaryColor,
                   ),
                 FlatButton(
                   child:  Text('ORDER NOW'),
                   onPressed: ()  {
                     Navigator.of(context).push(
                       MaterialPageRoute(
                         builder: (ctx) =>   OrderLocation(cart: cart),
                       ),
                     );

                   },
                   textColor: Theme.of(context).primaryColor,
                 )

                 ],
               ),
             ),
           ),
           SizedBox(height: 10),
           Expanded(
             child: ListView.builder(
               itemCount: cart.items.length,
               itemBuilder: (ctx, i) => Cart_Item(
                 cart.items.values.toList()[i].id,
                 cart.items.keys.toList()[i],
                 cart.items.values.toList()[i].price,
                 cart.items.values.toList()[i].quantity,
                 cart.items.values.toList()[i].title,
               ),
             ),
           )
         ],
       ),



    );
  }
}


