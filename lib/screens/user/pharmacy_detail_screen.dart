import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidbusters/providers/pharmacies.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PharmacyDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  _PharmacyDetailScreen createState() => _PharmacyDetailScreen();
}

class _PharmacyDetailScreen extends State<PharmacyDetailScreen> {
  var markers = HashSet<Marker>();
  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Pharmacies>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.all(10.0),
                height: 300,
                width: double.infinity,
                child: GoogleMap(
                  mapType: MapType.normal,
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  zoomGesturesEnabled: true,
                  zoomControlsEnabled: true,
                  onMapCreated: (GoogleMapController googleMapController) {
                    setState(() {
                      markers.add(
                        Marker(
                          markerId: MarkerId('1'),
                          position:
                              LatLng(loadedProduct.lat, loadedProduct.lng),
                        ),
                      );
                    });
                  },
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(loadedProduct.lat, loadedProduct.lng),
                    zoom: 17,
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              child: const Text('Go to Google Maps',
                  style: TextStyle(fontSize: 20)),
              onPressed: () {
                openMap(loadedProduct.lat, loadedProduct.lng);
              },
            )
          ],
        ),
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
