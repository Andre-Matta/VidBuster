import 'package:flutter/foundation.dart';

class Pharmacy with ChangeNotifier {
  final String id;
  final String name;
  final String location;
  final String imageUrl;
  var avaliableMedicines = new List(10);
  double distance;
  final double lat;
  final double lng;
  bool haveDelivery = false ;
  Pharmacy(
      {this.id,
      this.name,
      this.location,
      this.imageUrl,
      this.avaliableMedicines,
      this.lat,
      this.lng,
      this.distance,
      this.haveDelivery});
}
