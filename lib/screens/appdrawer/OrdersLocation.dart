import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/Selected.dart';
import 'package:vidbusters/providers/cart.dart';
import 'package:vidbusters/providers/orders.dart';
import 'package:vidbusters/shared/decorations.dart';
import 'package:vidbusters/widgets/appdrawer/appdrawer.dart';
String phone , area ,streetAddress , building, floor;
double lat ,lng;

class OrderLocation extends StatefulWidget {
  final Cart cart;

  const OrderLocation({Key key, this.cart}) : super(key: key);

  _OrderLocation createState()=> _OrderLocation(cart);

}
class _OrderLocation extends State<OrderLocation>{
  final Cart cart;
  Future getlocation() async {
    final locData = await Location().getLocation();
  lat = locData.latitude;
  lng = locData.longitude;
  }
  _OrderLocation(this.cart);
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text('Add delivery address'),
        ),
        drawer: AppDrawer(),
    body: SingleChildScrollView(

     child: Column(
      children: <Widget>[
        Form(
        child: Column(
          children: <Widget>[
            SizedBox(
              height:30,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child:Text(
                  "Basic info",
                  style: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
            SizedBox(
              height:10,
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration:
              textinputdecoration.copyWith(hintText: "Your phone number" , fillColor: Color(0x66CDAA)),
              onChanged: (value) {
                setState(() {
              phone = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration:
              textinputdecoration.copyWith(hintText: "Area" , fillColor: Color(0x66CDAA)),
              onChanged: (value) {
                setState(() {
                 area = value;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              cursorColor: Colors.black,
              decoration:
              textinputdecoration.copyWith(hintText: "Street Address", fillColor: Color(0x66CDAA)),
              onChanged: (value) {
                setState(() {
                 streetAddress = value ;
                });
              },
            ),
            SizedBox(
              height: 10,
            ),

            TextFormField(
              cursorColor: Colors.black,
              decoration:
              textinputdecoration.copyWith(hintText: "Building", fillColor: Color(0x66CDAA)),
              onChanged: (value) {
                setState(() {
                  building = value;
                });
              },
            ),
            SizedBox(
                  height: 10,
                ),

            TextFormField(
              cursorColor: Colors.black,
              decoration:
              textinputdecoration.copyWith(hintText: "Floor", fillColor: Color(0x66CDAA)),
              onChanged: (value) {
                setState(() {
                   floor = value;
                });
              },
            ),
            SizedBox(
              height:10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child:Text(
                  "Additional info",
                  style: TextStyle(fontWeight: FontWeight.bold)
              ),
            ),
            SizedBox(
              height:10,
            ),
            Container(
              padding: new EdgeInsets.all(7.0),
              alignment: Alignment.centerLeft,
            child:FlatButton.icon(
             label:  Text('Add your location'),
              icon: Icon(
                Icons.add_location_rounded,

              ),
              onPressed: () {
                setState(() {
                  getlocation().then((value) => {

                  });
                });
              },
            ),

            ),

            SizedBox(
              height: 30,
            ),

                  OrderButton(cart: cart),


          ],
        )
    )
    ])
    )
    );

  }

}
class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          :
         () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
            widget.cart.totalAmount,
            Selected.userEmail,
            phone,
            area,
            streetAddress,
            building,
            floor,
          lat,lng
        );
        setState(() {
          _isLoading = false;
        });
        widget.cart.clear();
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}