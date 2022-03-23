import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidbusters/providers/orders.dart' as ord;

class pharmacyOrder_item extends StatefulWidget {
  final ord.OrderItem order;

  pharmacyOrder_item(this.order);

  @override
  _pharmacyOrder_itemState createState() => _pharmacyOrder_itemState();
}

class _pharmacyOrder_itemState extends State<pharmacyOrder_item> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
          title: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
             padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child:
                ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        prod.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${prod.quantity}x ${prod.price} L.E',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),

                )
                    .toList(),


              ),
            ),
          if (_expanded )
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              alignment: Alignment.centerLeft,
              child:
               Row(
                children: [
                Icon(
                    Icons.phone
                ),
                  widget.order.phone!=null?Text('  '+widget.order.phone): Text(' ')
              ],
              )
            ),
          if (_expanded)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                alignment: Alignment.centerLeft,
                child:
                Column(
               children:[ 
                 Row(
                  children: [
                    Icon(
                        Icons.location_city
                    ),
                    Column(
                      children: [
                        widget.order.area!=null || widget.order.street!=null ? Text('  '+widget.order.area+ ' , '+widget.order.street):Text(' '),
                        widget.order.building!=null ? Text('Building: '+widget.order.building):Text(' '),
                        widget.order.floor!=null ? Text('Floor: '+widget.order.floor):Text(' ')
                      ],
                    ),
                  ],
                ),
                 widget.order.lat != null ? Row(
                   children: [
                     IconButton(
                         icon:Icon(Icons.location_on_outlined),
                       onPressed: (){
                         openMap(widget.order.lat, widget.order.lng);
                       },
                     ),
                     Text('show location on map')
                   ],
                 ):Text(''),
               ]
                )
            )
        ],
      ),
    );
  }
}
Future<void> openMap(double latitude, double longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunch(googleUrl)) {
    await launch(googleUrl);
  } else {
    throw 'Could not open the map.';
  }
}